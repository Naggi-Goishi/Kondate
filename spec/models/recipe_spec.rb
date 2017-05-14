require 'pry'
require_relative '../spec_helper.rb'

describe 'Recipe' do
  let (:step) { create(:recipe_step) }
  let (:ingredients_recipe) { create(:ingredients_recipe) }
  let (:recipe) { create(:recipe, ingredients_recipes: [ingredients_recipe], steps: [step]) }
  let (:ingredient) { create(:ingredient, recipes: [recipe]) }
  let (:recipe_kind) { create(:recipe_kind, recipes: [recipe]) }

  context 'scope' do
    it 'return recipes that has ingredient corresponding hiragana' do
      expect(Recipe.has_ingredient_hiragana(ingredient.hiragana)).to include recipe
    end

    it 'return recipes that has corresponding ingredient' do
      expect(Recipe.has_ingredient(ingredient)).to include recipe
    end

    it 'return recipes that has corresponding ingredient' do
      expect(Recipe.has_ingredients(Ingredient.where(name: ingredient.name))).to include recipe
    end

    it 'return recipes that has corresponding recipe kind' do
      expect(Recipe.has_recipe_kinds_name(recipe_kind.name)).to include recipe
    end
  end

  context 'association' do
    it 'belongs to recipe_kind' do
      recipe_kind
      expect(recipe.recipe_kind).to eq recipe_kind
    end

    it 'has many ingredients_recipes' do
      expect(recipe.ingredients_recipes).to include ingredients_recipe
    end

    it 'has many ingredients' do
      recipe = build(:recipe, ingredients: [ingredient])
      expect(recipe.ingredients).to include ingredient
    end

    it 'has many steps' do
      expect(recipe.steps).to include step
    end
  end

  context 'callback' do
    it 'counts recipe after creating recipe' do
      ingredient = build(:ingredient)
      recipe = create(:recipe, ingredients: [ingredient])
      expect(ingredient.recipes_count).to eq 1
    end
  end

  context 'instance methods' do
    it 'return true if it has the ingredient' do
      expect(recipe.has_ingredient?(ingredient)).to be_truthy
    end

    it 'return false if it has not the ingredient' do
      recipe = build(:recipe)
      expect(recipe.has_ingredient?(ingredient)).to be_falsy
    end

    it 'return true if it has all the ingredient' do
      recipe = create(:recipe, ingredients: [ingredient])
      expect(recipe.has_ingredient?(ingredient)).to be_truthy
    end
  end

end