require 'sinatra'
require 'line/bot'
require 'sinatra/activerecord'
require_relative './app_helper'
require_relative './models/base'

set :database_file, "./config/database.yml"

get '/recipe/import' do
  Recipe.import
  'imported'
end

post '/callback' do
  body = request.body.read
  events = get_events(request, body)

  validate_signature(request, body)

  events.each do |event|
    case event
    when Line::Bot::Event::Message
      process_for_message(event)
    end
  end

  "OK"
end

