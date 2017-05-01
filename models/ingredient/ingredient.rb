require_relative './scraping'

class Ingredient < ActiveRecord::Base
  include Scraping

  has_many :ingredients_recipes
  has_many :recipes, through: :ingredients_recipes

  def eq_name? (ingredient)
    name == ingredient.name
  end

  def eq_hiragana? (ingredient)
    hiragana == ingredient.hiragana
  end
end