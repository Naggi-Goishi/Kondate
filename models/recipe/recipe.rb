require 'mechanize'
require_relative './scraping'

class Recipe < ActiveRecord::Base
  include Scraping

  def self.random
    return "あれれー。データがないみたいー。作成者のなぎくんに連絡してみてー！" if Recipe.all.length == 0
    Recipe.find(rand(Recipe.all.length))
  end

  def show
    name + "\n( " + url + " ) "
  end
end
