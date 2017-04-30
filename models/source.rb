class Source
  @@kinds = { asking_recipe: '献立', ingredients: '材料'}
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

  FLAGS = {
    is_ingridients: false,
    is_recipe: false,
    is_recipe_kind: false
  }

  Ingredients = Struct.new(:contents) do
    def show
      (contents.inject('') { |text, ingredient| text + 'と' + ingredient.name } + 'を使う料理')[1..-1]
    end
  end

  attr_accessor :ingredients, :kind, :kind_en, :recipe_kind, :recipes, :klass, :text

  def initialize(text, flags)
    FLAGS.merge(flags)

    @text = text
    @recipe_kind = get_recipe_kind
    if FLAGS[:is_ingridients]
      @ingredients = get_ingredients
      @kind = @@kinds[:ingredients]
    elsif FLAGS[:is_recipe]
      @recipes = Recipe.where(name: @text).random(4)
    else
      @kind = get_kind
    end
    @kind_en = get_en(@@kinds, @kind)
  end

  def self.kinds
    @@kinds
  end

  def self.recipe_kinds
    @@recipe_kinds
  end

private
  def get_kind
    if @recipe_kind
      return @@kinds[:asking_recipe]
    else
      @@kinds.each do |_, kind|
        return kind if text_contains(kind)
      end
    end
    false
  end

  def get_recipe_kind
    @@recipe_kinds.each do |_, recipe_kind|
      return RecipeKind.find_by(name: recipe_kind) if text_contains(recipe_kind)
    end
    false
  end

  def get_en(kinds, kind)
    kinds.each do |en, ja|
      return en if kind == ja 
    end
    false
  end

  def get_ingredients
    ingredients = if @text.match(/、/)
      @text.split(/、/)
    elsif @text.match(/\n/)
      @text.split(/\n/)
    else
      [@text]
    end

    ingredients.map! { |ingredient| Ingredient.find_by(name: ingredient) }
    Ingredients.new(ingredients)
  end

  def text_contains(string)
    Regexp.new(string).match(@text)
  end
end
