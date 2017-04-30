require_relative './scraping'

class Recipe < ActiveRecord::Base
  include Scraping

  scope :main,   -> { joins(:recipe_kind).where.not(recipe_kinds: { name: "デザート" }) }
  scope :random, -> (num) { order('RAND()')[0..num] }
  scope :where_ingredient_name, -> (name) { joins(:ingredients).where(ingredients: { name: name }) }
  scope :where_ingredients, -> (ingredients) {
    where_ingredient_name(ingredients.first.name).random(-1).select do |recipe|
      ingredients[1..-1].all? { |ingredient| recipe.has_ingredient?(ingredient) }
    end
  }
  scope :where_recipe_kinds_name, -> (recipe_kinds) { joins(:recipe_kind).where(recipe_kinds: { name: recipe_kinds }) }

  belongs_to :recipe_kind
  has_many :ingredients_recipes
  has_many :ingredients, through: :ingredients_recipes

  def has_ingredient?(ingredient)
    ingredients.include?(ingredient)
  end

  def build
    name + "\n( " + url + " ) "
  end
end
