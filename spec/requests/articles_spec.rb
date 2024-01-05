# spec/controllers/articles_controller_spec.rb
require 'rails_helper'

RSpec.describe ArticlesController, type: :controller do
  let(:user) { create(:user) } # Assuming you have a factory for User
  let(:article) { create(:article) } # Assuming you have a factory for Article

  before do
    sign_in user
  end

  describe 'GET #index' do
    it 'renders the index template' do
      get :index
      expect(response).to render_template(:index)
    end

    it 'assigns @articles, @most_searched, and @trending' do
      search_logs = create_list(:search_log, 5, user: user)
      
      get :index
      expect(assigns(:articles)).to eq(Article.take(5))
      expect(assigns(:most_searched)).to be_present
      expect(assigns(:trending)).to be_present
    end
  end

  describe 'GET #show' do
    it 'renders the show template' do
      get :show, params: { id: article.id }
      expect(response).to render_template(:show)
    end
  end

  describe 'GET #new' do
    it 'renders the new template' do
      get :new
      expect(response).to render_template(:new)
    end
  end

  describe 'GET #edit' do
    it 'renders the edit template' do
      get :edit, params: { id: article.id }
      expect(response).to render_template(:edit)
    end
  end
  
end
