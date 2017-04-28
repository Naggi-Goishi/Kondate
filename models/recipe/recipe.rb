require 'mechanize'
require_relative './scraping'

class Recipe < ActiveRecord::Base
  include Scraping

  scope :main,   -> { includes(:recipe_kind).where.not(recipe_kinds: {name: "デザート"}) }
  scope :random, -> { order('RAND()').first }
  scope :where_recipe_kind, -> (recipe_kind) { includes(:recipe_kind).where(recipe_kinds: {name: recipe_kind}) }

  belongs_to :recipe_kind

  def show
    name + "\n( " + url + " ) "
  end
end
