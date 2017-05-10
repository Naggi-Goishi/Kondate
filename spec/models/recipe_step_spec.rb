require_relative '../spec_helper'

describe 'RecipeStep' do
  let (:recipe) { create(:recipe) }
  let (:step) { create(:recipe_step, recipe: recipe) }

  context 'assosiation' do
    it 'belongs to recipe' do
      expect(step.recipe).to eq recipe
    end
  end
end