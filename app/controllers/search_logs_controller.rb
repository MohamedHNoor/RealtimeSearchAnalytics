class SearchLogsController < ApplicationController
  before_action :authenticate_user!

  def index
    @search_logs = current_user.search_logs
  end

  def most_searched
   @most_searched = SearchLog.most_searched(current_user) || {}
  end

  def trending
    @trending = SearchLog.trending(current_user)  || {}
  end
end