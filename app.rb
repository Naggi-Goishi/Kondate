require 'line/bot'
require 'sinatra/base'
require 'sinatra/activerecord'
require 'mechanize'
require 'slim'
require 'json'
require_relative './app_helper'
require_relative './meta/base'
require_relative './models/base'

class KondateChan < Sinatra::Base
  include AppHelper

  helpers do
    def protect!
      unless authorized?
        response['WWW-Authenticate'] = %(Basic realm="Restricted Area")
        throw(:halt, [401, "Not authorized\n"])
      end
    end

    def authorized?
      @auth ||=  Rack::Auth::Basic::Request.new(request.env)
      username = ENV['BASIC_AUTH_USERNAME']
      password = ENV['BASIC_AUTH_PASSWORD']
      @auth.provided? && @auth.basic? && @auth.credentials && @auth.credentials == [username, password]
    end
  end

  set :database_file, "./config/database.yml"

  ActiveRecord::Base.connection.tables.each do |table_name|
    get "/admin/tables/#{table_name}" do
      protect!
      Model = table_name.classify.constantize
      @table = Model.all
      @column_names = Model.column_names[1..-1]

      slim :table
    end
  end

  get '/ingredients' do
    @ingredients = Ingredient.where(hiragana: nil)

    slim :ingredients
  end

  post '/ingredients' do
    data = JSON.parse(params.keys.first)
    data.each do |id, value|
      next if !value.hiragana?
      Ingredient.find(id).update(hiragana: value)
     end

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
