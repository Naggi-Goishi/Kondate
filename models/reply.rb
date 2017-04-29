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
    @message = get_message
  end

  def send
    @client.reply_message(@event['replyToken'], @message)
  end

  def create_text(text)
    {
      type: 'text',
      text: text
    }
  end

  def create_button
    {
      "type": "template",
      "altText": "this is a buttons template",
      "template": {
          "type": "buttons",
          "title": "メニュー",
          "text": "献立ですね！今日のご飯を一緒に考えましょう！",
          "actions": [
              {
                "type": "postback",
                "label": "材料から",
                "data": "action=ingredient"
              },
              {
                "type": "postback",
                "label": "食べ物から",
                "data": "action=recipe"
              },
              {
                "type": "uri",
                "label": "種類から",
                "uri": "action=recipe_kind"
              }
          ]
      }
    }
  end

  def get_message
    case @source.kind
    when Source.kind[:asking_recipe]
      return @source.recipe_kind ? create_text(get_recipe) : create_button
    else
      return create_text(@@replys[@source.kind_en])
    end
  end

  def get_recipe
    @@replys[@source.kind_en] + "・#{random_recipe(@source.recipe_kind.to_s)}"
  end

private
  def random_recipe(recipe_kind)
    if recipe_kind == 'false'
      Recipe.main.random.show
    else
      Recipe.where_recipe_kind(recipe_kind).random.show
    end
  end
end
