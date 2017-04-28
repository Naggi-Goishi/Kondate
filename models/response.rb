class Response
  def initialize(source)
    @source = Source.new(source)
  end

  def get_response
    case @source.type
    when Source.type[:asking_menu]
      "献立ですか？本日の献立候補のリストを送りますね！\n\n・#{Recipe.random.show}"
    when Source.type[:adding_ingredients]
      '了解です！どのような材料がありますか？'
    when Source.type[:removing_ingredients]
      '間違えでしたね！どの材料が必要ないですか？'
    end
  end
end
