require 'sinatra/activerecord/rake'
require './app'

namespace :scrape do

  task :recipes do
    Recipe.import
  end

  task :recipe_kinds do
    RecipeKind.import
  end

  task :recipe_steps do
    RecipeStep.import
  end

  task :ingredients do
    Ingredient.import
  end

  task :all do
    RecipeKind.import
    Recipe.import
    Ingredient.import
  end

  namespace :recipes do
    task :name do
      Recipe.import_names
    end

    task :recipe_kind_id do
      Recipe.import_recipe_kind_id
    end

    task :thumbnail_image_url do
      Recipe.import_thumbnail_image_url
    end

    task :time do
      Recipe.import_time
    end
  end

  namespace :ingredients do
    task :hiragana do
      Ingredient.import_hiragana
    end
  end
end

task :import_recipes_count do
  Ingredient.all.each do |ingredient|
    ingredient.recipes_count = Recipe.has_ingredient(ingredient).count
    ingredient.save
  end
end
