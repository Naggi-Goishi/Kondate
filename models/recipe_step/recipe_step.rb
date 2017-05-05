require_relative './scraping'

class RecipeStep < ActiveRecord::Base
  include Scraping

  belongs_to :recipe
end