require_relative './scraping'

class Ingredient < ActiveRecord::Base
  include Scraping

  scope :uncommon, -> { order(recipes_count: :asc) }

  has_many :ingredients_recipes
  has_many :recipes, through: :ingredients_recipes

  class << self
    def show
      return false if all.blank?
      all.inject('') do |text, ingredient|
        return text + '...' if text.length > 30
        text + ingredient.name + '、'
      end[0..-2]
    end
  end

  def counts_recipe
    self.recipes_count = 1 + recipes_count.to_i
    save
  end

end
