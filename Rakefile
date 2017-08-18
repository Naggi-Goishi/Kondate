require 'sinatra/activerecord/rake'
require 'csv'
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
    RecipeStep.import
  end

  task :base_100 do
    RecipeKind.import
    Recipe.import_base_names
    Recipe.import_base_recipe_kind_id
    Recipe.import_thumbnail_image_url
    Recipe.import_time
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

    task :by_recipe_kind do
      Recipe.import_recipes_by_recipe_kind
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

task :import_hiragana do 
  Ingredient.all.each do |ingredient|
    i = 0
    CSV.foreach('db/csv/ingredients_view.csv') do |row|
      i += 1
      next if i == 1
      if row[1] == ingredient.name
        print '#'
        ingredient.hiragana = row[2]
        ingredient.save
      end
    end
  end
end
