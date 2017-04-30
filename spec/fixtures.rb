class Fixtures
  def self.carousel(recipe, text)
    actions = [Action.new('uri', 'サイトへ', recipe.url)]
    columns = [Column.new(recipe.thumbnail_image_url, recipe.name, text, actions)]
    Carousel.new(columns).build
  end

  def self.button
    Button.new(Reply::MENU_BUTTON[:title], Reply::MENU_BUTTON[:text], Reply::MENU_BUTTON[:actions]).build
  end
end