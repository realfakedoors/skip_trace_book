class AlbumsController < ApplicationController
  before_action :set_album, only: [:show, :destroy]

  def show
  end

  def new
    @album = Album.new
  end

  def create
    @album = Album.new(album_params)
    
    if @album.save
      redirect_to @album, notice: "Album created!"
    else
      render :new, notice: "Unable to create album!"
    end
  end

  def destroy
    @album.destroy
    redirect_to root_url, notice: "Album deleted."
  end

  private
    def set_album
      @album = Album.find(params[:id])
    end

    def album_params
      params.require(:album).permit(:title, :description, :user_id)
    end
end
