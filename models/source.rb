class Source
  @@type = { asking_menu: '献立', adding_ingredients: '材料追加', removing_ingredients: '材料削除'}

  attr_accessor :type

  def initialize(text)
    @text = text
    @type = evaluateType
  end

  def self.type
    @@type
  end

private
  def evaluateType
    case  
    when (text_contains(@@type[:asking_menu]))
      @@type[:asking_menu]
    when (text_contains(@@type[:adding_ingredients]))
      @@type[:adding_ingredients]
    when (text_contains(@@type[:removing_ingredients]))
      @@type[:removing_ingredients]
    end
  end

  def text_contains(type)
    Regexp.new(type).match(@text)
  end
end
