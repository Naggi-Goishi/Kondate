require_relative './scraping'

class Recipe < ActiveRecord::Base
  include Scraping
  after_create :counts_recipe

  default_scope { order('RAND()') }

  scope :has_ingredients, -> (ingredients) {
    joins(:ingredients).where(ingredients: { hiragana: ingredients.pluck(:hiragana) } ) if ingredients 
  }

  belongs_to :recipe_kind
  has_many :ingredients_recipes
  has_many :ingredients, through: :ingredients_recipes
  has_many :steps, class_name: 'RecipeStep'

private
  def counts_recipe
    self.ingredients.each { |ingredient| ingredient.counts_recipe }
  end
end
