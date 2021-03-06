require_relative '../spec_helper'

describe 'Source' do
  let (:ingredient)  { create(:ingredient) }
  let (:recipe_kind) { create(:recipe_kind) }
  let (:recipe) { create(:recipe, ingredients: [ingredient], recipe_kind: recipe_kind) }

  context 'is recipe' do
    it 'has recipes, accordingly' do
      source = Source.new(recipe.name, is_recipe: true)
      expect(source.recipes).to include recipe
    end

    it 'has recipes with correct wording list, accordingly (飲みたい)' do
      source = Source.new(recipe.name + 'が飲みたい')
      expect(source.recipes).to include recipe
    end

    it 'has recipes with correct wording list, accordingly (食べたい)' do
      source = Source.new(recipe.name + 'が食べたい')
      expect(source.recipes).to include recipe
    end
  end

  context 'is ingredients' do
    it 'has ingredient with ingredients list, accordingly' do
      source = Source.new(ingredient.name, is_ingredients: true)
      expect(source.ingredients).to include ingredient
    end

    it 'has ingredient with correct wording list, accordingly' do
      source = Source.new(ingredient.name + 'を使用したレシピ')
      expect(source.ingredients).to include ingredient
    end
  end

  context 'is recipe_kind' do
    it 'has recipe kind, accordingly' do
      source = Source.new(recipe_kind.name, is_recipe_kind: true)
      expect(source.recipe_kind).to eq recipe_kind
    end

    it 'has recipe_kind with correct wording list, accordingly' do
      source = Source.new(recipe_kind.name + 'が食べたい', is_recipe_kind: true)
      expect(source.recipe_kind).to eq recipe_kind
    end
  end
end
