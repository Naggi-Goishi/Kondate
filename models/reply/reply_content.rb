class ReplyContent

  def initialize(source)
    @source = source
  end

  def ingredients
    Reply.source_is_ingredients = false
    reply(Recipe.has_ingredients(@source.ingredients))
  end

  def message
    menu_button.build
  end

  def next_recipes
    reply(@source.recipes)
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

  def recipe
    Reply.source_is_recipe = false
    reply(@source.recipes)
  end

  def recipe_kind
    Reply.source_is_recipe_kind = false
    reply(@source.recipe_kind.try(:recipes))
  end

private
  def get_recipes(all_recipes)
    all_recipes.take(5)
  end

  def get_next_recipes(all_recipes)
    all_recipes - get_recipes(all_recipes)
  end

  def menu_button
    Button.new(Reply::MENU_BUTTON[:title], Reply::MENU_BUTTON[:text], Reply::MENU_BUTTON[:actions])
  end

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

  def reply(all_recipes)
    columns = set_next_recipes_and_get_columns(all_recipes)
    columns.blank? ? Message.new(Reply::WORDINGS[:no_recipes]).build : Carousel.new(columns).build
  end

  def set_next_recipes_and_get_columns(all_recipes)
    return unless all_recipes

    Source.next_recipes = get_next_recipes(all_recipes)
    recipes_to_columns(get_recipes(all_recipes))
  end
end
