class UrlsController < ApplicationController
  def index
  end

  def show
  end

  def new
  end

  def create
    if params[:url].length == 0
      flash[:error] = "You need to enter a URL at the minimum."
      redirect_to root_path
      return
    end

    url        = params[:url]
    custom_url = params[:custom_url] || Url.create_hashed_url(params[:url])

    @msg       = Url.check_options(url, custom_url)
logger.debug "msg hash: #{@msg}"
    if @msg[:url][:count] > 0 && params[:force_cb] != 1
      flash[:notice] = "There are currently #{msg[:count]} instances of the url #{url} in use, please consider using one of the following:"
      @custom = msg[:url][:data]
      redirect_to root_path
      return
    elsif @msg[:custom_url] == true
      flash[:error] = "The custom url, #{custom_url} you have requested is already in use."
      redirect_to root_path
      return
    else
    end

    url_obj = Url.create(full_url: url, hashed_url: custom_url)

    redirect_to root_path, :notice => "Successfully created custom url: http://evi.io/#{custom_url}"
  end

  def edit
  end

  def delete
  end
end
