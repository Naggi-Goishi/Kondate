require_relative './scraping'

class Recipe < ActiveRecord::Base
  include Scraping

  scope :main,   -> { joins(:recipe_kind).where.not(recipe_kinds: {name: "デザート"}) }
  scope :random, -> { order('RAND()').first }
  scope :random, -> (num) { order('RAND()')[0..num] }
  scope :where_ingredients, -> (ingredients) { joins(:ingredient).where(ingredients: {name: ingredients}) }
  scope :where_recipe_kinds, -> (recipe_kinds) { joins(:recipe_kind).where(recipe_kinds: {name: recipe_kinds}) }

  belongs_to :recipe_kind
  has_many :ingredients_recipes
  has_many :ingredients, through: :ingredients_recipes

  def build
    name + "\n( " + url + " ) "
  end
end
