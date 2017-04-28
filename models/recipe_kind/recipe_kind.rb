require_relative './scraping'

class RecipeKind < ActiveRecord::Base
  include Scraping
end
