class SearchController < ApplicationController

  def index
    if params[:q].nil?
      @models = []
    else
      @models = SearchController.search_all params[:q]
    end
  end

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

  def self.search_all(query)
    search_hash = make_search_hash(query)
    Elasticsearch::Model.search(query, [Article, Person])
  end

  def self.make_search_hash(query)
    {
      query: {
        multi_match: {
          query: query,
          fields: ['title^10', 'text', 'name^10', 'age']
        }
      },
      highlight: {
        pre_tags: ['<em>'],
        post_tags: ['</em>'],
        fields: {
          title: {},
          text: {}
        }
      }
    }
  end
end
