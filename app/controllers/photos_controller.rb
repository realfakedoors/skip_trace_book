class PhotosController < ApplicationController
  before_action :set_photo,            except: [:new, :index, :create]
  before_action :correct_user,         only:   [:edit, :update, :destroy]
  before_action :check_for_friendship, only:    :show

  def index
  end
  
  def new
    @photo = Photo.new
  end

  def show
  end

  def create
    @photo = Photo.new(photo_params)

    if @photo.save
      redirect_to edit_album_url(@photo.album), notice: "Photo was successfully created!"
    else
      redirect_to root_url, notice: "Unable to save photo!"
    end
  end
  
  def edit
  end
  
  def update
  end

  def destroy
    album = @photo.album
    @photo.destroy
    redirect_to edit_album_url(album), notice: 'Photo was successfully destroyed.'
  end

  private

    def photo_params
      params.require(:photo).permit(:album_id, :photo_data, :title, :description)
    end
    
    def set_photo
      @photo = Photo.find(params[:id])
    end
    
    def user_logged_in?
      true if current_user == @photo.album.user
    end
    
    def check_for_friendship
      unless user_logged_in? || @photo.album.user.confirmed_friends?(current_user)
        redirect_to root_url, notice: "You can't view photos of non-friends!"
      end
    end
    
    def correct_user
      unless user_logged_in?
        redirect_to root_url, notice: "That's not yours to edit!"
      end
    end
end
