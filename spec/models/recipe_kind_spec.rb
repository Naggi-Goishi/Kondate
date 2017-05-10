require_relative '../spec_helper'

describe 'RecipeKind' do
  let (:recipe) { create(:recipe) }
  let (:recipe_kind) { create(:recipe_kind, recipes: [recipe]) }

  context 'assosiation' do
    it 'has many to recipe' do
      expect(recipe_kind.recipes).to include recipe
    end
  end
end