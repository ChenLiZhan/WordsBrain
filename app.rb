require 'sinatra/base'
require 'haml'
require 'sinatra/flash'
require 'data_mapper'
require './words.rb'

class WordsBrainApp < Sinatra::Base
  helpers WordHelpers

  configure :development do
    DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/development.db")
  end

  get '/' do

  end
end
