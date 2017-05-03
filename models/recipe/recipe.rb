require_relative './scraping'

class Recipe < ActiveRecord::Base
  include Scraping

  scope :has_ingredient_hiragana, -> (hiragana) { joins(:ingredients).where(ingredients: { hiragana: hiragana }) }
  scope :has_recipe_kinds_name, -> (recipe_kinds) { joins(:recipe_kind).where(recipe_kinds: { name: recipe_kinds }) }
  scope :has_ingredient, -> (ingredient) { has_ingredient_hiragana(ingredient.hiragana) }
  scope :has_ingredients, -> (ingredients) {
    has_ingredient(ingredients[0]).select(&[:has_all_ingredients?, ingredients[1..-1]])
  }

  belongs_to :recipe_kind
  has_many :ingredients_recipes
  has_many :ingredients, -> { order('RAND()') }, through: :ingredients_recipes

  def has_ingredient?(ingredient)
    ingredients.include?(ingredient)
  end

  def has_all_ingredients?(ingredients)
    ingredients.all? { |ingredient| has_ingredient?(ingredient) }
  end

  def ingredients
    Ingredients.new(association(:ingredients).reader)
  end
end
