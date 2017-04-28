require 'mechanize'
require_relative './scraping'

class Recipe < ActiveRecord::Base
  include Scraping

  belongs_to :recipe_kind

  def self.random(recipe_kind)
    if (recipe_kind)
      recipes = Recipe.where(recipe_kind: recipe_kind)
      recipes[rand(recipes.length)]
    else
      Recipe.all[rand(Recipe.all.length)]
    end
  end

  def show
    name + "\n( " + url + " ) "
  end
end
