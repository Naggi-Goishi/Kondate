class Reply
  @@replys = {
    asking_recipe: "献立ですか？本日の献立候補のリストを送りますね！\n\n",
    adding_ingredients: '了解です！どのような材料がありますか？',
    removing_ingredients: '間違えでしたね！どの材料が必要ないですか？'
  }

  def initialize(client, events)
    @client = client
    @event  = events.first
    @source = Source.new(@event.message['text'])
  end

  def send
    message = {
      type: 'text',
      text: get_text
    }
    @client.reply_message(@event['replyToken'], message)
  end

  def get_text
    case @source.kind
    when Source.kind[:asking_recipe]
      @@replys[@source.kind_en] + "・#{Recipe.random(@source.recipe_kind.to_s).show}"
    else
      @@replys[@source.kind_en]
    end
  end
end
