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
    case @content
    when Array
      @content.each do |content|
        @client.reply_message(@event['replyToken'], content)
      end
    else
      @client.reply_message(@event['replyToken'], @content)
    end
  end

  def get_content
    if @source.kind == Source.kinds[:adding_ingredients]
      thumbnail_image_url = 'https://c-chefgohan.gnst.jp/imgdata/recipe/90/00/90/rc732x546_1209090617_e73e7d03237e70e759dfd90c84c24733.jpg'
      title = '卵焼き'
      column_text = "玉子焼き\n野永 喜三夫シェフのレシピ"
      actions = [Action.new('uri', 'サイトへ', 'https://chefgohan.gnavi.co.jp/detail/90')]
      columns = [Column.new(thumbnail_image_url, title, column_text, actions)]
      reply = @source.ingredients.inject { |text, ingredient| text + 'と' + ingredient }
      @@is_ingredients = false
      content = [Message.new(reply + 'でお料理を検索しますね！')]
      content << Carousel.new(columns).build
      p content
      content
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
      Recipe.main.random.show
    else
      Recipe.where_recipe_kind(recipe_kind).random.show
    end
  end
end
