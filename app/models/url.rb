class Url
  include Mongoid::Document
  field :fu, as: :full_url, type: String
  field :hu, as: :hashed_url, type: String
  field :cb, as: :created_by, type: String
  field :cd, as: :created_date, type: DateTime, default: ->{ Time.now }

  def self.create_hashed_url(url)
    require 'zlib'
    return Zlib::crc32 url
  end

  def self.check_options(url, custom_url)
    msg = { :url => {} }

    url_results = self.where(:full_name => url)
    custom_url  = self.where(:hashed_url => custom_url)

    msg[:url][:count] =  url_results.count
    msg[:url][:data]  =  url_results
    msg[:custom_url]  =  custom_url.exists?

    return msg
  end
end
