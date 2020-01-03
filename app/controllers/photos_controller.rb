class PhotosController < ApplicationController
  before_action :set_photo,            except: [:new,  :create]
  before_action :correct_user,         only:   [:edit, :update, :destroy]
  before_action :check_for_friendship, only:    :show
  
  def new
    @photo = Photo.new
  end

  def show
  end

  def create
    @photo = Photo.new(photo_params)
    if @photo.save
      redirect_back fallback_location: @photo, notice: "Photo was successfully created!"
    else
      redirect_to root_url, notice: "Unable to save photo!"
    end
  end
  
  def edit
  end
  
  def update
    if @photo.update(photo_params)
      redirect_to @photo, notice: 'photo updated!'
    else
      render :edit, notice: 'Failed to update photo!'
    end
  end

  def destroy
    @photo.destroy
    redirect_back fallback_location: root_url, notice: 'Photo was successfully destroyed.'
  end

  private

    def photo_params
      params.require(:photo).permit(:photo_data, :title, :description, :photo_attachable_id, :photo_attachable_type)
    end
    
    def set_photo
      @photo = Photo.find(params[:id])
    end
    
    def user_logged_in?
      true if current_user == @photo.photo_attachable.user
    end
    
    def check_for_friendship
      unless user_logged_in? || @photo.photo_attachable.user.confirmed_friends?(current_user)
        redirect_to root_url, notice: "You can't view photos of non-friends!"
      end
    end
    
    def correct_user
      unless user_logged_in?
        redirect_to root_url, notice: "That's not yours to edit!"
      end
    end
end
