require 'sinatra/activerecord/rake'
require './app'

namespace :scrape do

  task :recipe do
    Recipe.import
  end

  task :recipe_kind do
    RecipeKind.import
  end

  task :ingredient do
    Ingredient.import
  end

  task :all do
    RecipeKind.import
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

  namespace :ingredient do
    task :hiragana do
      Ingredient.import_hiragana
    end
  end
end
