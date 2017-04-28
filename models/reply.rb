class Reply
  def initialize(client, events)
    @client = client
    @source = Source.new(getSource(events))
  end

  def send
    message = {
      type: 'text',
      text: get_text
    }
    @client.reply_message(event['replyToken'], message)
  end

  def get_text
    case @source.type
    when Source.type[:asking_menu]
      "献立ですか？本日の献立候補のリストを送りますね！\n\n・#{Recipe.random.show}"
    when Source.type[:adding_ingredients]
      '了解です！どのような材料がありますか？'
    when Source.type[:removing_ingredients]
      '間違えでしたね！どの材料が必要ないですか？'
    end
  end


private
  def getSource(events)
    events.each do |event|
      return event.message['text']
    end
  end
end
