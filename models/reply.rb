class Reply
  @@replys = {
    asking_recipe: "献立ですか？本日の献立候補のリストを送りますね！\n\n",
    adding_ingredients: '了解です！どのような材料がありますか？',
    removing_ingredients: '間違えでしたね！どの材料が必要ないですか？'
  }

  def initialize(client, events)
    @client = client
    @event  = events.first
    @source = get_source
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
                "data": "ingredient"
              },
              {
                "type": "postback",
                "label": "食べ物から",
                "data": "recipe"
              },
              {
                "type": "postback",
                "label": "種類から",
                "data": "recipe_kind"
              }
          ]
      }
    }
  end

  def get_message
    case @souorce.klass
    when Line::Bot::Event::Postback
      case @text
      when 'ingredient'
        create_text('材料から考えるのですね！お使いになる材料を、「改行」もしくは「、」でわけて送ってください！\n\n 例１）人参\n玉ねぎ\nじゃがいも\n\n例２)人参、玉ねぎ、じゃがいも')
      when 'recipe'
        create_text('お調べになりたい。料理名を教えてください！')
      when 'recipe_kind'
        create_text('現在、９つの中から検索いただけます！「和食」「洋食」「中華」「フレンチ」「イタリアン」「スパニッシュ」「アジアン」「エスニック」「デザート」です！')
      end
    when Line::Bot::Event::Message
      case @source.kind
      when Source.kind[:asking_recipe]
        p create_button
        return @source.recipe_kind ? create_text(get_recipe) : create_button
      else
        return create_text(@@replys[@source.kind_en])
      end
    end
  end

  def get_recipe
    @@replys[@source.kind_en] + "・#{random_recipe(@source.recipe_kind.to_s)}"
  end

  def get_source
    case @event
    when Line::Bot::Event::Postback
      Source.new(@event['postback']['data'], Line::Bot::Event::Postback)
    when Line::Bot::Event::Message
      Source.new(@event.message['text'], Line::Bot::Event::Message)
    end
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
