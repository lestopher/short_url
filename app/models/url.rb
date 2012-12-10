class Url
  include Mongoid::Document
  field :full_url, type: String
  field :hashed_url, type: String
  field :created_by, type: String
  field :created_date, type: DateTime, default: ->{ Time.now }

  def self.create_hashed_url(url)
    require 'zlib'
    return Zlib::crc32 url
  end

  def self.check_options(url, custom_url)
    
  end
end
