class Button
  def initialize(title, text, actions)
    @title =  title
    @text = text
    @actions = actions
  end

  def build
    {
      "type": "template",
      "altText": "this is a buttons template",
      "template": {
          "type": "buttons",
          "title": @title,
          "text": @text,
          "actions": @actions.map { |action| action.build }
      }
    }
  end
end