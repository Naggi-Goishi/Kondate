require 'sinatra'
require 'line/bot'
require_relative 'app_helper'

post '/callback' do
  events = get_events(request)

  validate_signature(request)

  events.each do |event|
    case event
    when Line::Bot::Event::Message
      process_for_message(event)
    end
  end

  "OK"
end
