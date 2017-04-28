require 'line/bot'
require 'sinatra/base'
require 'sinatra/activerecord'
require_relative './app_helper'
require_relative './models/base'

class KondateChan < Sinatra::Base
  include AppHelper

  set :database_file, "./config/database.yml"

  get '/recipe/import' do
  Recipe.import
  'imported'
  end

  post '/callback' do
  body = request.body.read
  events = get_events(request, body)

  validate_signature(request, body)

  Response.new(events).send

  "OK"
  end

end