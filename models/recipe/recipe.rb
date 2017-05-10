require_relative './scraping'

class Recipe < ActiveRecord::Base
  include Scraping
  after_create :counts_recipe

  default_scope { order('RAND()') }

  scope :has_ingredient_hiragana, -> (hiragana) { joins(:ingredients).where(ingredients: { hiragana: hiragana }) }
  scope :has_ingredient, ->  (ingredient) { has_ingredient_hiragana(ingredient.hiragana) }
  scope :has_ingredients, -> (ingredients) {
    has_ingredient(ingredients.uncommon[0]).select(&[:has_all_ingredients?, ingredients[1..-1]])
  }
  scope :has_recipe_kinds_name, -> (recipe_kinds) { joins(:recipe_kind).where(recipe_kinds: { name: recipe_kinds }) }

  belongs_to :recipe_kind
  has_many :ingredients_recipes
  has_many :ingredients, through: :ingredients_recipes
  has_many :steps, class_name: 'RecipeStep'

  def has_ingredient?(ingredient)
    ingredients.include?(ingredient)
  end

  def has_all_ingredients?(ingredients)
    ingredients.all? { |ingredient| has_ingredient?(ingredient) }
  end

private
  def counts_recipe
    self.ingredients.each { |ingredient| ingredient.counts_recipe }
  end
end
