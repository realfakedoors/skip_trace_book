class PhotosController < ApplicationController
  before_action :set_photo,            only: [:show, :destroy]
  before_action :check_for_friendship, only:  :show

  def show
  end

  def create
    @photo = Photo.new(photo_params)

    if @photo.save
      redirect_to @photo,   notice: "Photo was successfully created!"
    else
      redirect_to root_url, notice: "Unable to save photo!"
    end
  end

  def destroy
    @photo.destroy
    redirect_to photos_url, notice: 'Photo was successfully destroyed.'
  end

  private

    def photo_params
      params.require(:photo).permit(:album_id, :photo_data, :title, :description)
    end
    
    def set_photo
      @photo = Photo.find(params[:id])
    end
    
    def check_for_friendship
      photo_owner = @photo.album.user
      unless current_user == photo_owner || photo_owner.confirmed_friends?(current_user)
        redirect_to root_url, notice: "You can't view photos of non-friends!"
      end
    end
end
