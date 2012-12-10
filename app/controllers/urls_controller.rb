class UrlsController < ApplicationController
  def index
  end

  def show
  end

  def new
    if params[:url].nil?
      redirect_to root_path
    end

    url        = params[:url]
    custom_url = params[:custom_url] || create_hashed_url(params[:url])

    

    url_obj = Url.new(full_url: url, hashed_url: custom_url)
  end

  def edit
  end

  def delete
  end
end
