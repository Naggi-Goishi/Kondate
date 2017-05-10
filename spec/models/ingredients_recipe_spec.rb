require_relative '../spec_helper'

describe 'IngredientsRecipe' do
  let (:ingredient) { create(:ingredient) }
  let (:recipe) { create(:recipe, ingredients: [ingredient]) }

  context 'assosiation' do
    it 'belongs to ingredient' do
      recipe
      ingredients_recipe = IngredientsRecipe.first
      expect(ingredients_recipe.ingredient).to eq ingredient
    end

    it 'belongs to recipe' do
      recipe
      ingredients_recipe = IngredientsRecipe.first
      expect(ingredients_recipe.recipe).to eq recipe
    end
  end
end