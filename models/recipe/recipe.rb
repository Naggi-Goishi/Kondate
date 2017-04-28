require 'mechanize'
require_relative './scraping'

class Recipe < ActiveRecord::Base
  include Scraping

  belongs_to :recipe_kind

  def self.random(recipe_kind)
    if (recipe_kind == "false")
      Recipe.all[rand(Recipe.all.length)]
    else
      recipes = RecipeKind.find_by(name: recipe_kind).recipes
      recipes[rand(recipes.length)]
    end
  end

  def show
    name + "\n( " + url + " ) "
  end
end
