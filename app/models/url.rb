class Url
  include Mongoid::Document

  # Document fields
  field :fu, as: :full_url, type: String
  field :hu, as: :hashed_url, type: String
  field :cb, as: :created_by, type: String
  field :cd, as: :created_date, type: DateTime, default: ->{ Time.now }
  field :rn, as: :record_number, type: Integer
  field :tv, as: :times_visited, type: Integer
  field :ah, as: :admin_hash, type: String

  # Do this before save
  before_save :set_record_number, :create_admin_hash

  # Adds record number to the document
  def set_record_number
    return if self.record_number != nil
    self.record_number = Url.count + 1
  end

  def create_admin_hash
    return if self.admin_hash != nil
    require 'base64'
    self.admin_hash = Base64.urlsafe_encode64(self.full_url + self.created_date + Random.rand(99))
  end

  # Updates the number of times visited
  def update_times_visited
    if self.times_visited.nil? || self.times_visited < 1
      self.times_visited = 1
    else
      self.times_visited += 1
    end

    save
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
