class ArticlesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_article, only: %i[ show edit update destroy ]

  # GET /articles or /articles.json
  def index
    @articles = Article.take(5)
    @most_searched = fetch_most_searched_queries
    @trending = fetch_trending_queries
  end

  def search
    if params.dig(:title_search).present?
      @articles = Article.filter_by_name(params[:title_search]).order(created_at: :desc)
      current_user.search_logs.create(query: params[:title_search])
    else
      @articles = []
    end
    respond_to do |format|
      format.turbo_stream do
          render turbo_stream: [
            turbo_stream.update("search_results",
            partial: "articles/search_results",
            locals: { articles: @articles })
          ]
      end
    end
  end

  # GET /articles/1 or /articles/1.json
  def show
  end

  # GET /articles/new
  def new
    @article = Article.new
  end

  # GET /articles/1/edit
  def edit
  end

  # POST /articles or /articles.json
  def create
    @article = Article.new(article_params)

    respond_to do |format|
      if @article.save
        format.html { redirect_to article_url(@article), notice: "Article was successfully created." }
        format.json { render :show, status: :created, location: @article }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @article.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /articles/1 or /articles/1.json
  def update
    respond_to do |format|
      if @article.update(article_params)
        format.html { redirect_to article_url(@article), notice: "Article was successfully updated." }
        format.json { render :show, status: :ok, location: @article }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @article.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /articles/1 or /articles/1.json
  def destroy
    @article.destroy!

    respond_to do |format|
      format.html { redirect_to articles_url, notice: "Article was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_article
      @article = Article.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def article_params
      params.require(:article).permit(:name, :description)
    end

    def fetch_most_searched_queries
      user = User.find_by(params[:id])
      queries_and_counts = SearchLog.where(user: user).group(:query).order('count_query desc').limit(5).count('query')
      queries_and_counts.sort_by { |_, count| -count }.to_h
    end

    def fetch_trending_queries
      user = User.find_by(params[:id])
      queries_and_counts = SearchLog.where(user: user).group(:query).order('max(created_at) desc').limit(5).count('query')
      queries_and_counts.sort_by { |_, count| -count }.to_h
  end
end
