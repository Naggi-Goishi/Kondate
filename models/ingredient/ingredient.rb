require_relative './scraping'

class Ingredient < ActiveRecord::Base
  include Scraping

  scope :uncommon, -> { order(recipes_count: :asc) }

  has_many :ingredients_recipes
  has_many :recipes, through: :ingredients_recipes

  def count_recipe
    recipes_count = 1 + recipes_count.to_i
    self.save
  end

  def self.include?(ingredient)
    all.any? do |record|
      record == ingredient || record.contains?(name: ingredient.name) || record.contains?(hiragana: ingredient.hiragana)
    end
  end

  def self.hiraganas
    all.group_by(&:hiragana).keys
  end

  def self.show
    return false if blank?
    all.inject('') do |text, ingredient|
      return text + '...' if text.length > 30
      text + ingredient.name + '、'
    end[0..-2]
  end

end
