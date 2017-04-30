require_relative './action'
require_relative './message'
require_relative './button'
require_relative './carousel/carousel'

class Reply
  @@replys = {
    asking_recipe: "献立ですか？本日の献立候補のリストを送りますね！\n\n",
    adding_ingredients: '了解です！どのような材料がありますか？',
    removing_ingredients: '間違えでしたね！どの材料が必要ないですか？'
  }
  @@is_ingredients = false

  def initialize(client, events)
    @client = client
    @event  = events.first
    @source = get_source
    @content = get_content
  end

  def send
    @client.reply_message(@event['replyToken'], @content)
  end

  def get_content
    if @source.kind == Source.kinds[:adding_ingredients]
      recipes = Recipe.where_ingredients(@source.ingredients).random_to(5)
      columns = recipes.map do |recipe|
        Column.new(
          recipe.thumbnail_image_url,
          recipe.name,
          '',
          [Action.new('uri', 'サイトへ', recipe.url)]
        )
      end
      @@is_ingredients = false
      return Carousel.new(columns).build
    end

    case @event
    when Line::Bot::Event::Postback
      case @source.text
      when 'ingredient'
        @@is_ingredients = true
        Message.new("材料から考えるのですね！お使いになる材料を、「改行」もしくは「、」でわけて送ってください！\n\n 例１）\n人参\n玉ねぎ\nじゃがいも\n\n例２)\n人参、玉ねぎ、じゃがいも").build
      when 'recipe'
        Message.new('お調べになりたい料理名を教えてください！').build
      when 'recipe_kind'
        Message.new("現在、９つの中から検索いただけます！どれにしますか？\n\n・和食\n・洋食\n・中華\n・フレンチ\n・イタリアン\n・スパニッシュ\n・アジアン\n・エスニック\n・デザート").build
      end
    when Line::Bot::Event::Message
      case @source.kind
      when Source.kinds[:asking_recipe]
        title = 'メニュー'
        text = '献立ですね！今日のご飯を一緒に考えましょう！'
        actions = [
          Action.new('postback', '材料から', 'ingredient'),
          Action.new('postback', '料理名から', 'recipe'),
          Action.new('postback', '種類から', 'recipe_kind')
        ]
        return @source.recipe_kind ? Message.new(get_recipe).build : Button.new(title, text, actions).build
      else
        return Message.new(@@replys[@source.kind_en])
      end
    end
  end

  def get_recipe
    @@replys[@source.kind_en] + "・#{random_recipe(@source.recipe_kind.to_s)}"
  end

  def get_source
    case @event
    when Line::Bot::Event::Postback
      Source.new(@event['postback']['data'])
    when Line::Bot::Event::Message
      Source.new(@event.message['text'], @@is_ingredients)
    end
  end

private
  def random_recipe(recipe_kind)
    if recipe_kind == 'false'
      Recipe.main.random.build
    else
      Recipe.where_recipe_kinds(recipe_kind).random.build
    end
  end
end
