require_relative './scraping'

class RecipeKind < ActiveRecord::Base
  include Scraping

  has_many :recipes
end
