class ReplyContent

  def initialize(source)
    @source = source
  end

  def ingredients
    Reply.source_is_ingredients = false
    set_columns(Recipe.has_ingredients(@source.ingredients)) if @source.ingredients
    reply
  end

  def recipe
    Reply.source_is_recipe = false
    set_columns(@source.recipes)
    reply
  end

  def recipe_kind
    Reply.source_is_recipe_kind = false
    set_columns(@source.recipe_kind.try(:recipes))
    reply
  end

  def next_recipes
    set_columns(@source.recipes)
    reply
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

  def set_columns(all_recipes)
    @columns = get_columns_and_set_next_recipes(all_recipes)
  end

  def get_columns_and_set_next_recipes(all_recipes)
    return unless all_recipes

    recipes = all_recipes.take(5)
    Source.next_recipes = all_recipes - recipes
    recipes_to_columns(recipes)
  end

  def reply
    @columns.blank? ? Message.new(Reply::WORDINGS[:no_recipes]).build : Carousel.new(@columns).build
  end
end
