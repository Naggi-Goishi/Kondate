require_relative './scraping'

class Ingredient < ActiveRecord::Base
  include Scraping

  has_many :ingredients_recipes
  has_many :recipes, through: :ingredients_recipes
end