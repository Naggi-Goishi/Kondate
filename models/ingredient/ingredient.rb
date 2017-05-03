require_relative './scraping'

class Ingredient < ActiveRecord::Base
  include Scraping

  scope :uncommon, -> { order(recipes_count: :asc) }

  has_many :ingredients_recipes
  has_many :recipes, through: :ingredients_recipes
end
