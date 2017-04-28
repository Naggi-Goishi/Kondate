require 'mechanize'
require_relative './scraping'

class Recipe < ActiveRecord::Base
  include Scraping

  def self.random
    Recipe.all[rand(Recipe.all.length)]
  end

  def show
    name + "\n( " + url + " ) "
  end
end
