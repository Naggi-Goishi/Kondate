require 'sinatra/activerecord/rake'
require './app'

namespace :scrape do

  task :recipe do
    Recipe.import
  end

  task :ingredient do
    Ingredient.import
  end

  task :all do
    Recipe.import
    Ingredient.import
  end

  namespace :recipe do
    task :names do
      Recipe.import_names
    end

    task :recipe_kind_id do
      Recipe.import_recipe_kind_id
    end

    task :thumbnail_image_url do
      Recipe.import_thumbnail_image_url
    end
  end
end
