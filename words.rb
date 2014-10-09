require 'sinatra/base'
require 'dm-core'
require 'dm-migrations'

class Words
  include DataMapper::Resource

  property :id, Serial
  property :word, String
  property :update_time, Date
end

DataMapper.finalize

module WordHelpers
  def find_text
    @word = Word.all
  end
end
