require 'bundler/setup'
require_relative './app'

$stdout.sync = true

run Sinatra::Application
