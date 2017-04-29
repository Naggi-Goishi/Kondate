class Source
  @@kinds = { asking_recipe: '献立', adding_ingredients: '材料追加', removing_ingredients: '材料削除'}
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

  attr_accessor :ingredients, :kind, :kind_en, :recipe_kind

  def initialize(text)
    @text = text
    @recipe_kind = get_recipe_kind
    @kind = get_kind
    @kind_en = get_en(@@kinds, @kind)
  end

  def self.kind
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
      return recipe_kind if text_contains(recipe_kind)
    end
    false
  end

  def get_en(kinds, kind)
    kinds.each do |en, ja|
      return en if kind == ja 
    end
  end

  def text_contains(string)
    Regexp.new(string).match(@text)
  end
end
