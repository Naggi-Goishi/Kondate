class ReplyContent

  def initialize(source)
    @source = source
  end

  def ingredients
    Reply.source_is_ingredients = false
    recipes = []

    unless @source.ingredients.blank?
      all_recipes = Recipe.has_ingredients(@source.ingredients)
      recipes = all_recipes.take(5)
      Source.next_recipes = all_recipes - recipes
      p Source.next_recipes.take(1)

      columns = recipes_to_columns(recipes)
    end
    recipes.blank? ? Message.new(Reply::WORDINGS[:no_recipes]).build : Carousel.new(columns).build
  end

  def recipe
    Reply.source_is_recipe = false
    columns = recipes_to_columns(@source.recipes.limit(5))

    columns.blank? ? Message.new(Reply::WORDINGS[:no_recipes]).build : Carousel.new(columns).build
  end

  def recipe_kind
    Reply.source_is_recipe_kind = false
    return Message.new(Reply::WORDINGS[:no_recipes]).build unless @source.recipe_kind

    recipes = Recipe.has_recipe_kinds_name(@source.recipe_kind.name).limit(5)
    columns = recipes_to_columns(recipes)

    Carousel.new(columns).build
  end

  def next_recipes
    recipes = @source.recipes.take(5)
    Source.next_recipes -= recipes
    columns = recipes_to_columns(recipes)
    recipes.blank? ? Message.new(Reply::WORDINGS[:no_recipes]).build : Carousel.new(columns).build
  end

  def postback
    case @source.text
    when 'ingredient'
      Reply.source_is_ingredients = true
      Message.new(Reply::WORDINGS[:explanation][:ingredients]).build
    when 'recipe'
      Reply.source_is_recipe = true
      Message.new(Reply::WORDINGS[:explanation][:recipe]).build
    when 'recipe_kind'
      Reply.source_is_recipe_kind = true
      Message.new(Reply::WORDINGS[:explanation][:recipe_kind]).build
    end
  end

  def message
    menu_button.build
  end

private
  def recipes_to_columns(recipes)
    if recipes.length > 5
      puts "Warning: in recipes_to_columns recipes's length should be 5 but " + recipes.length
      recipes = recipes.take(5)
    end
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
end
