class Source
  @@kinds = { recipe: '献立', ingredients: '材料' }
  @@recipe_kinds = {
    japanese: '和食',
    western: '洋食',
    chinese: '中華',
    french: 'フレンチ',
    italian: 'イタリアン',
    spanish: 'スパニッシュ',
    asian: 'アジアン',
    ethnic: 'エスニック',
    dessert: 'デザート'
  }
  @@next_recipes = []

  DEFAULT_FLAGS = {
    is_ingridients: false,
    is_recipe: false,
    is_recipe_kind: false
  }.freeze

  attr_accessor :ingredients, :recipe_kind, :recipes, :text, :recipe_name

  def initialize(text, flags=DEFAULT_FLAGS)
    @text = text
    @flags = flags
    evaluate
  end

  def self.kinds
    @@kinds
  end

  def self.recipe_kinds
    @@recipe_kinds
  end

  def self.next_recipes
    @@next_recipes
  end

  def self.next_recipes=(next_recipes)
    @@next_recipes = next_recipes
  end

  def ingredients?
    @flags[:is_ingredients] || text_matches_to_ingredients_wordings?
  end

  def recipe?
    @flags[:is_recipe] || text_matches_to_recipes_name_wordings?
  end

  def recipe_kind?
    @flags[:is_recipe_kind] || text_matches_to_recipes_kind_wordings?
  end

  def next_recipes?
    @@next_recipes.present? && (@text.match? (/他|次/))
  end

private
  def evaluate
    case
    when recipe_kind?
      @recipe_kind = get_recipe_kind
    when recipe?
      @recipes = get_recipes
    when ingredients?
      @ingredients = get_ingredients
    when next_recipes?
      @recipes = @@next_recipes
    end
  end

  def get_recipes
    @recipe_name = @text.gsub(/が食べたい.*\z/, '')
    Recipe.contains(name: @recipe_name)
  end

  def get_recipe_kind
    @@recipe_kinds.each do |_, recipe_kind|
      return RecipeKind.find_by(name: recipe_kind) if @text.match? (recipe_kind)
    end
    false
  end

  def get_ingredients
    ingredients = if @text.match(/、/)
      @text.split(/、/)
    elsif @text.match(/\n/)
      @text.split(/\n/)
    elsif @text.match(/と/)
      @text.split(/と/)
    else
      [@text]
    end

    ingredients.map! { |ingredient| ingredient.gsub(/(を使った|を使用した|を使用する|を使う).+\z/, '') }

    ids = ingredients.map do |ingredient|
      if ingredient.to_hiragana
        Ingredient.find_by(hiragana: ingredient.to_hiragana).try(:id)
      else
        Ingredient.find_by(name: ingredient).try(:id)
      end
    end.flatten

    Ingredient.where(id: ids)
  end

  def text_matches_to_ingredients_wordings?
    @text.match? (/(を使った|を使用した|を使用する|を使う)*+(ゴハン|料理|レシピ|ごはん|ご飯)/)
  end

  def text_matches_to_recipes_name_wordings?
    @text.match? (/が食べたい/)
  end

  def text_matches_to_recipes_kind_wordings?
    @@recipe_kinds.any? { |_, recipe_kind| recipe_kind == @text.match(/(.+)が食べたい/)[1] } if @text.match? (/(.+)が食べたい/)
  end
end
