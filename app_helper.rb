def client
  @client ||= Line::Bot::Client.new { |config|
    config.channel_secret = ENV["LINE_CHANNEL_SECRET"]
    config.channel_token = ENV["LINE_CHANNEL_TOKEN"]
  }
end

def get_events(request)
  body = request.body.read
  client.parse_events_from(body)
end

def getReplay(text)
  if (/献立/ === text)
    return "献立ですか？本日の献立候補のリストを送りますね！"
  end
  "わかりません"
end

def process_for_message(event)
  case event.type
  when Line::Bot::Event::MessageType::Text
    process_for_text(event)
  end
end

def process_for_text(event)
    message = {
      type: 'text',
      text: getReplay(event.message['text'])
    }
    client.reply_message(event['replyToken'], message)
end

def validate_signature(request)
  signature = request.env['HTTP_X_LINE_SIGNATURE']
  unless client.validate_signature(body, signature)
    error 400 do 'Bad Request' end
  end
end