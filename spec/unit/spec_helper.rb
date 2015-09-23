require 'rubygems'
require 'bundler/setup'

Bundler.require(:default)


require 'active_record'
require 'active_support/all'
require 'tablematic'

require 'with_model'
#require 'ruby-debug'
require 'ostruct'
#require 'xmlsimple'


RSpec.configure do |config|
  config.extend WithModel
  ActiveRecord::Base.establish_connection(:adapter => "sqlite3", :database => ":memory:")
end


# ENV["RAILS_ENV"] ||= 'test'
# require File.expand_path("../dummy/config/environment", __FILE__)
# require 'database_cleaner'
# require_relative '../lib/tablematic'

# RSpec.configure do |config|
#   config.before(:suite) do
#     DatabaseCleaner.strategy = :transaction
#     DatabaseCleaner.clean_with(:truncation)
#     Rails.application.load_seed # loading seeds
#   end
# end
