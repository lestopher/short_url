class UrlsController < ApplicationController
  def index
    # This section deals with asking the user if they're sure that 
    # they want to create another db record, isntead of using an existing one
    if !params[:used_url].nil?
      @records = Url.where(:full_url => params[:used_url]).to_a
      return
    end

    # Case 1: No url
    # Case 2: Url, returns nothing
    # Case 3: Url, returns good

    document = Url.where(:hashed_url => params[:url]).first unless params[:url].nil?
    flash[:error] = "The url you entered: #{params[:url]}, is invalid." if !params[:url].nil? && document.nil?

    # Didn't find anything, wah wah
    return unless !document.nil?

    # This section deals with redirecting to a url if it's found
    protocol = "http://" if document.full_url.match(/^(https|http):\/\//).nil?
    redirect_to "#{protocol}#{document.full_url}" and return
  end

  def show
    @records = Url.where(:hashed_url => params[:url]).to_a
  end

  def all
    @records = Url.all.to_a
    render 'urls/show'
  end

  def new
  end

  def create
    # C'mon son, you need at least a url to get started
    if params[:url].length == 0
      flash[:error] = "You need to enter a URL at the minimum."
      redirect_to root_path
      return
    end

    url        = params[:url]
    custom_url = !params[:custom_url].empty? ? params[:custom_url] : Url.create_hashed_url(params[:url])
    msg        = Url.check_options(url, custom_url)

    if msg[:url][:count] > 0 && params[:force_cb].to_i != 1
      flash[:notice] = "There are currently #{msg[:url][:count]} instances of the url #{url} in use, please consider using one of the following:"
      @records = msg[:url][:data]
      redirect_to root_path :used_url => url
      return
    elsif msg[:custom_url] == true
      flash[:error] = "The custom url, #{custom_url} you have requested is already in use."
      redirect_to root_path
      return
    else
      # Seriously, I need to use an else block here if there's an elsif
    end

    url_obj = Url.create(full_url: url, hashed_url: custom_url)

    redirect_to root_path, :notice => "Successfully created custom url: http://#{site_name}/#{custom_url}"
  end

  def edit
  end

  def delete
  end
end
