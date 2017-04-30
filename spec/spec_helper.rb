require 'rack/test'
require 'rspec'
require 'factory_girl'
require 'database_cleaner'
require_relative './fixtures'

ENV['RACK_ENV'] = 'test'

require File.expand_path '../../app.rb', __FILE__

module RSpecMixin
  include Rack::Test::Methods
  def app() KondateChan end
end

RSpec.configure do |config| 
  config.include RSpecMixin
  config.include FactoryGirl::Syntax::Methods
  config.before(:suite) do
    DatabaseCleaner.clean_with :truncation  # clean DB of any leftover data
    DatabaseCleaner.strategy = :transaction # rollback transactions between each test    
    FactoryGirl.find_definitions
  end
  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end
end

