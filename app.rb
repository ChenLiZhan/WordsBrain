require 'sinatra/base'
require 'haml'
require 'sinatra/flash'
require 'data_mapper'
require 'dm-core'
require 'dm-migrations'
require 'json'

class Words
  include DataMapper::Resource

  property :id, Serial
  property :word, String
  property :created_time, DateTime
end

DataMapper.finalize

module Wordshelpers
  def exist?
    Words.count(:word => params[:word]) == 0
  end

  def length_equal_one?
    params[:word].length == 1
  end

  def cn?
    cn = /[\u4e00-\u9fa5]/
    (params[:word] =~ cn) != nil
  end

  def create_word
    Words.create(:word => params[:word], :created_time => Time.now)
  end
end

class WordsBrainApp < Sinatra::Base
  helpers Wordshelpers

  configure :development do
    DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/development.db")
  end

  get '/' do
    @words = Words.all
    haml :index
  end

  post '/' do
    create_word if exist? && length_equal_one? && cn?
    redirect to('/')
  end

  post '/ajax' do
    content_type :json
    Words.all.map { |word| word.word }.to_json
  end
end
