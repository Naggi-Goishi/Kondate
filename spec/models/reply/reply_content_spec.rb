require_relative '../../spec_helper'

describe ReplyContent do
  let(:ingredient) { create(:ingredient) }
  let(:recipe_kind) { create(:recipe_kind) }
  let(:recipe) { create(:recipe, recipe_kind: recipe_kind, ingredients: [ingredient]) }

  describe 'インスタンスメソッド' do
    context 'ingredients method' do
      it '適当なcarouselを返す' do
        carousel = Fixtures.carousel(recipe)
        source = Source.new(ingredient.name, is_ingredients: true)
        result = ReplyContent.new(source).ingredients

        expect(result).to include carousel
      end

      it '該当する材料がない場合' do
        recipe
        source = Source.new('ほげ', is_ingredients: true)
        result = ReplyContent.new(source).ingredients

        expect(result).to eq Message.new(ReplyContent::NO_RECIPE).build
      end
    end

    context 'recipe method' do
      it '適当なcarouselを返す' do
        carousel = Fixtures.carousel(recipe)
        source = Source.new(recipe.name, is_recipe: true)
        result = ReplyContent.new(source).recipe

        expect(result).to include carousel
      end

      it '該当するレシピがない場合' do
        recipe
        source = Source.new('ほげ', is_recipe: true)
        result = ReplyContent.new(source).ingredients

        expect(result).to eq Message.new(ReplyContent::NO_RECIPE).build
      end
    end

    context 'recipe_kind method' do
      it '適当なcarouselを返す' do
        carousel = Fixtures.carousel(recipe)
        source = Source.new(recipe.recipe_kind.name, is_recipe_kind: true)
        result = ReplyContent.new(source).recipe_kind

        expect(result).to include carousel
      end

      it '該当するレシピがない場合' do
        recipe
        source = Source.new('ほげ', is_recipe_kind: true)
        result = ReplyContent.new(source).recipe_kind

        expect(result).to eq Message.new(ReplyContent::NO_RECIPE).build
      end
    end


    context 'postback method' do
      it 'Sourceがingredientな時、適当なcarouselを返す' do
        source = Source.new('ingredient')
        result = ReplyContent.new(source).postback

        expect(result).to eq Message.new(Reply::REPLYS[:ingredients]).build
      end

      it 'Sourceがrecipeな時、適当なcarouselを返す' do
        source = Source.new('recipe')
        result = ReplyContent.new(source).postback

        expect(result).to eq Message.new(Reply::REPLYS[:recipe]).build
      end

      it 'Sourceがrecipe_kindな時、適当なcarouselを返す' do
        source = Source.new('recipe_kind')
        result = ReplyContent.new(source).postback

        expect(result).to eq Message.new(Reply::REPLYS[:recipe_kind]).build
      end
    end

    context 'message method' do
      it 'Sourceが「献立」を含む時、適当なBottonを返す' do
        source = Source.new('献立なににしよー')
        result = ReplyContent.new(source).message

        expect(result).to eq Fixtures.button
      end
    end
  end
end
