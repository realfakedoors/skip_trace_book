class AlbumsController < ApplicationController
  before_action :set_album,            except: [:new, :create, :index]
  before_action :check_for_friendship, only:   [:index, :show]
  before_action :correct_user,         only:   [:edit,  :update, :destroy]

  def index
  end
  
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
  
  def edit
  end
  
  def update
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
    
    def user_logged_in?
      true if current_user == @album.user
    end
    
    def check_for_friendship
      unless user_logged_in? || @album.user.confirmed_friends?(current_user)
        redirect_to root_url, notice: "You can't view albums of non-friends!"
      end
    end
    
    def correct_user
      unless user_logged_in?
        redirect_to root_url, notice: "That's not yours to edit!"
      end
    end
end
