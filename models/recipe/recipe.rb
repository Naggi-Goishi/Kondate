require_relative './scraping'

class Recipe < ActiveRecord::Base
  include Scraping

  scope :main,   -> { joins(:recipe_kind).where.not(recipe_kinds: {name: "デザート"}) }
  scope :random, -> { order('RAND()').first }
  scope :where_ingredients, -> (ingredients) { joins(:ingredient).where(ingredients: {name: ingredients}) }
  scope :where_recipe_kind, -> (recipe_kind) { joins(:recipe_kind).where(recipe_kinds: {name: recipe_kind}) }

  belongs_to :recipe_kind
  has_many :ingredients_recipes
  has_many :ingredients, through: :ingredients_recipes

  def show
    name + "\n( " + url + " ) "
  end
end
