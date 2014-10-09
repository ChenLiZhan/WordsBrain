require 'sinatra/base'
require 'haml'
require 'sinatra/flash'
require 'data_mapper'
require 'dm-core'
require 'dm-migrations'

class Words
  include DataMapper::Resource

  property :id, Serial
  property :word, String
  property :created_time, DateTime
end

DataMapper.finalize

module Wordshelpers
  def create_word(word)
    Words.count(:word => "#{params[:word]}") == 0 ? Words.create(:word => params[:word], :created_time => Time.now) : false
  end
end

class WordsBrainApp < Sinatra::Base
  helpers Wordshelpers
  enable :method_override

  configure do
    enable :sessions
  end

  configure :development do
    DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/development.db")
  end

  get '/' do
    @words = Words.all
    haml :index
  end

  post '/' do
    create_word
    redirect to('/')
  end
end
