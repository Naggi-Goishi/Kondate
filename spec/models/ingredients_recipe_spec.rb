require_relative '../spec_helper'

describe 'IngredientsRecipe' do
  let (:ingredient) { create(:ingredient) }
  let (:recipe) { create(:recipe) }
  let (:ingredients_recipe) { create(:ingredients_recipe, recipe: recipe, ingredient: ingredient) }

  context 'assosiation' do
    it 'belongs to ingredient' do
      expect(ingredients_recipe.ingredient).to eq ingredient
    end

    it 'belongs to recipe' do
      expect(ingredients_recipe.recipe).to eq recipe
    end
  end
end