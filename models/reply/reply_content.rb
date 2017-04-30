class ReplyContent

  def initialize(source)
    @source = source
  end

  def ingredients
    Reply.source_is_ingredients = false
    return Message.new('すみません！該当するレシピがありませんでした。').build if @source.ingredients.contents.first.nil?
    names   = @source.ingredients.contents.pluck(:name)
    recipes = Recipe.where_ingredients_names(names).random(4)
    columns = recipes_to_columns(recipes)

    Carousel.new(columns).build
  end

  def recipe
    Reply.source_is_recipe = false
    p @source.recipes
    return Message.new('すみません！該当するレシピがありませんでした。').build if @source.recipes.blank?
    columns = recipes_to_columns(@source.recipes)

    Carousel.new(columns).build
  end

  def recipe_kind
    Reply.source_is_recipe_kind = false
    return Message.new('・・・認識できませんでした。９つの中から選んでくださいね！').build if @source.recipe_kind.nil?
    recipes = Recipe.where_recipe_kinds_name(@source.recipe_kind.name).random(4)
    columns = recipes_to_columns(recipes)

    Carousel.new(columns).build
  end

  def postback
    case @source.text
    when 'ingredient'
      Reply.source_is_ingredients = true
      Message.new(Reply::REPLYS[:ingredients]).build
    when 'recipe'
      Reply.source_is_recipe = true
      Message.new(Reply::REPLYS[:recipe]).build
    when 'recipe_kind'
      Reply.source_is_recipe_kind = true
      Message.new(Reply::REPLYS[:recipe_kind]).build
    end    
  end

  def message
    case @source.kind
    when Source.kinds[:asking_recipe]
      recipes = Recipe.where_recipe_kinds_name(@source.recipe_kind.try(:name)).random(4)
      columns = recipes_to_columns(recipes)

      @source.recipe_kind ? Carousel.new(columns).build : menu_button.build
    end
  end

private
  def recipes_to_columns(recipes)
    recipes.map do |recipe|
      Column.new(
        recipe.thumbnail_image_url,
        recipe.name,
        @source.ingredients.try(:show) || '説明無し',
        [Action.new('uri', 'サイトへ', recipe.url)]
      )
    end
  end

  def menu_button
    Button.new(Reply::MENU_BUTTON[:title], Reply::MENU_BUTTON[:text], Reply::MENU_BUTTON[:actions])
  end
end