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

    # Update times visited
    document.update_times_visited

    @redirectLink = "#{protocol}#{document.full_url}"
    render 'layouts/redirect', :layout => false
  end

  def show
    @records = Url.where(:hashed_url => params[:url]).to_a
  end

  def all
    @records = Url.all

    @records = @records.to_a if @records.respond_to? 'to_a'
    render 'urls/show'
  end

  def new
  end

  def create
    # C'mon son, you need at least a url to get started
    if params[:url].length == 0
      flash[:error] = "You need to enter a URL at the minimum."
      redirect_to root_path and return
    end

    url        = params[:url]
    custom_url = !params[:custom_url].empty? ? params[:custom_url].downcase : Url.create_hashed_url(params[:url])
    msg        = Url.check_options(url, custom_url)
    site_name  = request.host_with_port
    @url       = Url.new({full_url: url, hashed_url: custom_url})

    # Check if the custom url is banned
    if Url.is_banned?(custom_url)
      flash[:error] = "You may not use special characters or swear words in your custom url"
      redirect_to root_path and return
    end

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

    if verify_recaptcha(:model => @url, :message => "Wrong reCAPTCHA") && @url.save
      redirect_to root_path, :notice => "Successfully created custom url: http://#{site_name}/#{custom_url}/nYour admin url is http://#{site_name}/urls/#{@url.admin_hash}/edit"
    else
      flash[:error] = @url.errors.full_messages.first
      redirect_to root_path
    end
  end

  def edit
    @record = Url.where(:admin_hash => params[:id]).to_a

    redirect_to(urls_path, { :error => "No edit path exists for that URL." }) and return if @record.empty?

    @record = @record.first
  end

  # The only thing that we allow them to update, will be the url, not the custom url
  def update
    @record = Url.where(:admin_hash => params[:id]).to_a

    if @record.empty?
      flash[:error] = "Could not update custom url with new link"
      redirect_to root_path and return
    end

    @record.first.update_attributes( :full_url => params[:url])
    flash[:notice] = "Successfully updated link"
    redirect_to root_path and return
  end

  def destroy
    @record = Url.where(:id => params[:id]).to_a

    @record.first.destroy and redirect_to root_path, :notice => "Successfully deleted link"  and return unless @record.empty?

    redirect_to root_path, :error => "#{params[:admin_hash]} was not found."
  end

  def admin
    puts "the hash is #{params[:hash]}\nenv is #{ENV['ADMIN_URL']}"
    unless params[:hash] == ENV['ADMIN_URL']
      redirect_to root_path and return
    end

    session[:admin_url] = params[:hash]
    render 'urls/admin'
  end

  def info
    if session[:admin_url].nil? or session[:admin_url] != ENV['ADMIN_URL']
      respond_to do |format|
        format.json { render :json => { :valid => false, :data => [] } }
      end
      return
    end

    allRecords = Url.all.to_a

    json = {
      :valid => true,
      :data => allRecords
    }

    respond_to do |format|
      format.json { render :json => json }
    end
  end
end
