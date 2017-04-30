require_relative './action'
require_relative './message'
require_relative './button'
require_relative './reply_content'
require_relative './carousel/carousel'

class Reply
  REPLYS = {
    asking_recipe: "献立ですか？本日の献立候補のリストを送りますね！\n\n",
    ingredients: "材料から考えるのですね！お使いになる材料を、「改行」もしくは「、」でわけて送ってください！\n\n 例１）\n人参\n玉ねぎ\nじゃがいも\n\n例２)\n人参、玉ねぎ、じゃがいも",
    recipe: 'お調べになりたい料理名を教えてください！',
    recipe_kind: "現在、９つの中から検索いただけます！どれにしますか？\n\n・和食\n・洋食\n・中華\n・フレンチ\n・イタリアン\n・スパニッシュ\n・アジアン\n・エスニック\n・デザート"
  }
  MENU_BUTTON = {
    title: 'メニュー',
    text: '献立ですね！今日のご飯を一緒に考えましょう！',
    actions: [
        Action.new('postback', '材料から', 'ingredient'),
        Action.new('postback', '料理名から', 'recipe'),
        Action.new('postback', '種類から', 'recipe_kind')
      ]
  }
  @@source_is_ingredients = false
  @@source_is_recipe = false
  @@source_is_recipe_kind = false

  def initialize(client, events)
    @client = client
    @event  = events.first
    @source = get_source
    @content = get_content
  end

  def send
    @client.reply_message(@event['replyToken'], @content)
  end

  def self.source_is_ingredients
    @@source_is_ingredients
  end

  def self.source_is_ingredients= (source_is_ingredients)
    @@source_is_ingredients = source_is_ingredients
  end

  def self.source_is_recipe
    @@source_is_recipe
  end

  def self.source_is_recipe= (source_is_recipe)
    @@source_is_recipe = source_is_recipe
  end

  def self.source_is_recipe_kind
    @@source_is_recipe_kind
  end

  def self.source_is_recipe_kind= (source_is_recipe_kind)
    @@source_is_recipe_kind = source_is_recipe_kind
  end

private
  def get_content
    p @@source_is_ingredients
    if @@source_is_ingredients
      ReplyContent.new(@source).ingredients
    elsif @@source_is_recipe
      ReplyContent.new(@source).recipe
    elsif @@source_is_recipe_kind
      ReplyContent.new(@source).recipe_kind
    else
      case @event
      when Line::Bot::Event::Postback
        ReplyContent.new(@source).postback
      when Line::Bot::Event::Message
        ReplyContent.new(@source).message
      end
    end
  end

  def get_source
    case @event
    when Line::Bot::Event::Postback
      Source.new(@event['postback']['data'])
    when Line::Bot::Event::Message
      Source.new(@event.message['text'], self.flags)
    end
  end

  def self.flags
    flags = {
      is_ingridients: @@source_is_ingredients,
      is_recipe: @@source_is_recipe,
      is_recipe_kind: @@source_is_recipe_kind
    }
  end
end
