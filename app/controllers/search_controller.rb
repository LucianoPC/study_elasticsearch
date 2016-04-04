class SearchController < ApplicationController

  def articles
    if params[:q].nil?
      @articles = []
    else
      @articles = Article.search params[:q]
    end
  end
end
