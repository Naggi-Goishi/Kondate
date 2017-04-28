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
    'success'
  end

  get '/recipe/import_recipe_kind_id' do
    Recipe.import_recipe_kind_id
    'success'
  end

  get '/recipe_kind/import' do
    RecipeKind.import
    'success'
  end

  post '/callback' do
    body = request.body.read
    events = get_events(request, body)
    validate_signature(request, body)

    puts 'recieved a message ....... '
    Reply.new(client, events).send

    "OK"
  end

end
