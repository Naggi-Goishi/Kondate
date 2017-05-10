require_relative '../spec_helper'

FactoryGirl.define do
  factory :ingredients_recipe do
    ingredient
    recipe
  end
end