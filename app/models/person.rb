class Person < ActiveRecord::Base
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks

  def self.search(query)
    __elasticsearch__.search(
      {
        query: {
          multi_match: {
            query: query,
            fields: ['name^10', 'age']
          }
        },
        highlight: {
          pre_tags: ['<em>'],
          post_tags: ['</em>'],
          fields: {
            name: {},
            age: {}
          }
        }
      }
    )
  end

  settings index: { number_of_shards: 1 } do
    mappings dynamic: 'false' do
      indexes :name, analyzer: 'english', index_options: 'offsets'
      indexes :age, analyzer: 'english'
    end
  end
end

Person.__elasticsearch__.client.indices.delete index: Person.index_name rescue nil

# Create the new index with the new mapping
Person.__elasticsearch__.client.indices.create \
  index: Person.index_name,
  body: { settings: Person.settings.to_hash, mappings: Person.mappings.to_hash }

# Index all Person records from the DB to Elasticsearch
Person.import
