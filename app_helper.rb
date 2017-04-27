def client
  @client ||= Line::Bot::Client.new { |config|
    config.channel_secret = ENV["LINE_CHANNEL_SECRET"]
    config.channel_token = ENV["LINE_CHANNEL_TOKEN"]
  }
end

def get_events(request, body)
  client.parse_events_from(body)
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
      text: Response.new(event.message['text']).get_response
    }
    client.reply_message(event['replyToken'], message)
end

def validate_signature(request, body)
  signature = request.env['HTTP_X_LINE_SIGNATURE']
  unless client.validate_signature(body, signature)
    error 400 do 'Bad Request' end
  end
end
