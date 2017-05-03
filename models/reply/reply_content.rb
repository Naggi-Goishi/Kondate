class ReplyContent
  NO_RECIPE = 'すみません！該当するレシピがありませんでした。'

  def initialize(source)
    @source = source
  end

  def ingredients
    Reply.source_is_ingredients = false
    recipes = []

    if !@source.ingredients.blank?
      recipes = Recipe.has_ingredients(@source.ingredients)[0..4]
      columns = recipes_to_columns(recipes)
    end
    no_recipe?(recipes) ? Message.new(NO_RECIPE).build : Carousel.new(columns).build
  end

  def recipe
    Reply.source_is_recipe = false
    columns = recipes_to_columns(@source.recipes)

    columns.blank? ? Message.new(NO_RECIPE).build : Carousel.new(columns).build
  end

  def recipe_kind
    Reply.source_is_recipe_kind = false
    return Message.new(NO_RECIPE).build unless @source.recipe_kind

    recipes = Recipe.has_recipe_kinds_name(@source.recipe_kind.name).limit(5)
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
    menu_button.build
  end

private
  def recipes_to_columns(recipes)
    recipes.map do |recipe|
      Column.new(
        recipe.thumbnail_image_url,
        recipe.name,
        recipe.ingredients.show || '説明無し',
        [Action.new('uri', 'サイトへ', recipe.url)]
      )
    end
  end

  def menu_button
    Button.new(Reply::MENU_BUTTON[:title], Reply::MENU_BUTTON[:text], Reply::MENU_BUTTON[:actions])
  end

  def no_recipe?(recipes)
    @source.ingredients.blank? || recipes.blank?
  end
end
