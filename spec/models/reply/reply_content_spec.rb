require_relative '../../spec_helper'

describe ReplyContent do
  let(:ingredient) { create(:ingredient) }
  let(:recipe_kind) { create(:recipe_kind) }
  let(:recipe) { create(:recipe, recipe_kind: recipe_kind, ingredients: [ingredient]) }

  describe 'インスタンスメソッド' do
    context 'ingredients method' do
      it '適当なcarouselを返す' do
        carousel = Fixtures.carousel(recipe, ingredient.name + 'を使う料理')
        source = Source.new(ingredient.name, {is_ingredients: true})
        result = ReplyContent.new(source).ingredients

        expect(result).to include carousel
      end

      it '該当するレシピがない場合' do
        recipe
        source = Source.new('ほげ', {is_ingredients: true})
        result = ReplyContent.new(source).ingredients

        expect(result).to eq Message.new('すみません！該当するレシピがありませんでした。').build
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

      it 'Sourceがrecipe_kindを含む時、適当なCarouselを返す' do
        carousel = Fixtures.carousel(recipe, '説明無し')
        source = Source.new('和食でなにかおいしいものある？')
        result = ReplyContent.new(source).message

        expect(result).to include carousel
      end
    end
  end
end
