class SearchController < ApplicationController

  def articles
    if params[:q].nil?
      @articles = []
    else
      @articles = Article.search params[:q]
    end
  end

  def people
    if params[:q].nil?
      @people = []
    else
      @people = Person.search params[:q]
    end
  end
end
