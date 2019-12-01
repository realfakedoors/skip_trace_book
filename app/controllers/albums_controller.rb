class AlbumsController < ApplicationController
  before_action :set_album,            only: [:show, :destroy]
  before_action :check_for_friendship, only:  :show

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

    def album_params
      params.require(:album).permit(:title, :description, :user_id)
    end
    
    def set_album
      @album = Album.find(params[:id])
    end
    
    def check_for_friendship
      album_owner = @album.user
      unless current_user == album_owner || album_owner.confirmed_friends?(current_user)
        redirect_to root_url, notice: "You can't view albums of non-friends!"
      end
    end
end
