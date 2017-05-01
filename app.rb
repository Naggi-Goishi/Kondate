require 'line/bot'
require 'sinatra/base'
require 'sinatra/activerecord'
require 'mechanize'
require 'slim'
require 'json'
require_relative './app_helper'
require_relative './meta/string'
require_relative './models/base'

class KondateChan < Sinatra::Base
  include AppHelper

  set :database_file, "./config/database.yml"

  before do
    @ingredients = Ingredient.where(hiragana: nil) if request.path_info = '/ingredients'
  end

  get '/ingredients' do
    @ingredients = Ingredient.where(hiragana: nil)

    slim :ingredients
  end

  post '/ingredients' do
    data = JSON.parse(params.keys.first)
    Ingredient.find(data['id']).update(hiragana: data['hiragana'])

    @ingredients = Ingredient.where(hiragana: nil)

    slim :ingredients, layout: false
  end

  post '/callback' do
    body = request.body.read
    events = get_events(request, body)
    validate_signature(request, body)

    Reply.new(client, events).send

    "OK"
  end

end
