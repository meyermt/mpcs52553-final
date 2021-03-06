class VideosController < ApplicationController
#AIzaSyDNp6dI2h-M4NfqAJN-dr5_9uiKfZA9MU8

  before_action :require_login

  def require_login
    @user = User.find_by(id: session[:user_id])
    if @user.blank?
      redirect_to root_url, notice: "You need to login first."
    end
  end

  def index
    @videos = Video.all
  end

  def show
    @video = Video.find_by(id: params["id"])
    script_title = @video.title.downcase.tr(' ', '_')
    level = find_video_level(@user.level)
    @script = JSON.parse(File.read("app/assets/json/#{script_title}_#{level}.json")).to_json
  end

  def new
    if @user.owner != true
      redirect_to root_url, notice: "You need to login as an owner first."
    end
    @video = Video.new
    render 'new'
  end

  def create
    if @user.owner != true
      redirect_to root_url, notice: "You need to login as an owner first."
    end
    @video = Video.new
    @video.title = params["title"]
    @video.description = params["description"]
    @video.director = params["director"]
    @video.loc_id = params["loc_id"]
    @video.icon_url = params["icon_url"]
    @video.script_root_url = params["script_root_url"]
    if @video.save
      redirect_to "/videos", notice: 'Product successfully created.'
    else
      render "new"
    end
  end

  def edit
    if @user.owner != true
      redirect_to root_url, notice: "You need to login as an owner first."
    end
    @video = Video.find_by(id: params["id"])
  end

  def update
    @user = User.find_by(id: session[:user_id])
    if @user.blank? || @user.owner != true
      redirect_to root_url, notice: "You need to login as an owner first."
    end
    @video = Video.find_by(id: params["id"])
    @video.title = params["title"]
    @video.description = params["description"]
    @video.director = params["director"]
    @video.loc_id = params["loc_id"]
    @video.icon_url = params["icon_url"]
    @video.script_root_url = params["script_root_url"]
    if @video.save
      redirect_to '/videos', notice: 'Video details have been updated'
    else
      render 'edit'
    end
  end

  def destroy
    @user = User.find_by(id: session[:user_id])
    if @user.blank? || @user.owner != true
      redirect_to root_url, notice: "You need to login as an owner first."
    end
    @video = Video.find_by(id: params["id"])
    @video.delete
    redirect_to root_url, notice: 'Video has been deleted'
  end

  def find_video_level(level)
    rounded = level.round(-2)
    if rounded == 0
      rounded = 100
    end
    return rounded
  end

end
