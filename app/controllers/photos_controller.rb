class PhotosController < ApplicationController
  before_action :set_photo, only: [:show, :destroy]

  def show
  end

  def create
    @photo = Photo.new(photo_params)

    if @photo.save
      redirect_to @photo, notice: "Photo was successfully created!"
    else
      render :new, notice: "Unable to save photo!"
    end
  end

  def destroy
    @photo.destroy
    redirect_to photos_url, notice: 'Photo was successfully destroyed.'
  end

  private
    def set_photo
      @photo = Photo.find(params[:id])
    end

    def photo_params
      params.require(:photo).permit(:album_id, :photo_data, :title, :description)
    end
end
