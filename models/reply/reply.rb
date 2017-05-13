require_relative './action'
require_relative './message'
require_relative './button'
require_relative './reply_content'
require_relative './carousel/carousel'

class Reply
  WORDINGS = ActiveSupport::HashWithIndifferentAccess.new(YAML.load_file('models/data/reply_data.yml'))
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
    if @source.ingredients?
      ReplyContent.new(@source).ingredients
    elsif @source.recipe?
      ReplyContent.new(@source).recipe
    elsif @source.recipe_kind?
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
      Source.new(@event.message['text'], Reply.flags)
    end
  end

  def self.flags
    {
      is_ingredients: @@source_is_ingredients,
      is_recipe: @@source_is_recipe,
      is_recipe_kind: @@source_is_recipe_kind
    }
  end
end
