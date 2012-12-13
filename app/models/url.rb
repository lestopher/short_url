class Url
  include Mongoid::Document

  # Document fields
  field :fu, as: :full_url, type: String
  field :hu, as: :hashed_url, type: String
  field :cb, as: :created_by, type: String
  field :cd, as: :created_date, type: DateTime, default: ->{ Time.now }
  field :rn, as: :record_number, type: Integer

  # Do this before save
  before_save :set_record_number

  # Adds record number to the document
  def set_record_number
    self.record_number = Url.count + 1
  end

  def self.create_hashed_url(url)
    require 'zlib'
    return Zlib::crc32 url
  end

  def self.check_options(url, custom_url)
    msg = { :url => {} }

    url_results = self.where(:full_url => url)
    custom_url  = self.where(:hashed_url => custom_url)

    msg[:url][:data]  =  url_results.to_a
    msg[:url][:count] =  url_results.count
    msg[:custom_url]  =  custom_url.exists?

    return msg
  end
end
