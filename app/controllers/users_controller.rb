class UsersController < ApplicationController
  before_action :set_user,             except: [:index, :new, :create, :received_friend_requests]
  before_action :check_for_friendship,   only: [:friends, :albums, :show]

  def index
    @users = User.paginate(page: params[:page])
  end
  
  def show
    @posts = @user.posts.paginate(page: params[:page], per_page: 10)
  end

  def new
    @user = User.new
  end

  def edit
  end

  def create
    @user = User.new(user_params)

    if @user.save
      redirect_to @user, notice: 'User was successfully created.'
    else
      render :new, notice: 'Failed to create user!'
    end
  end

  def update
    if @user.update(user_params)
      redirect_to @user, notice: 'User was successfully updated.'
    else
      render :edit, notice: 'Failed to update user!'
    end
  end

  def destroy
    @user.destroy
    redirect_to users_url, notice: 'User was successfully destroyed.'
  end
  
  def friends
    @initiated_friendships = @user.friendships
    @accepted_friends      = @initiated_friendships.where(accepted: true).map { |f| f.friend }
    @friends               = @accepted_friends.paginate(page: params[:page], per_page: 9)
    render 'show_friends'
  end
  
  def albums
    @albums = @user.albums.paginate(page: params[:page], per_page: 6)
    render 'albums/index'
  end
  
  def received_friend_requests
    @unanswered_friendships = Friendship.where(accepted: false).where(friend_id: current_user.id).to_a
                  @requests = @unanswered_friendships.paginate(page: params[:page], per_page: 9)
  end

  private
    def set_user
      @user = User.find(params[:id])
    end

    def user_params
      params.require(:user).permit(:name, :email, :profile_picture)
    end
    
    def check_for_friendship
      unless @user == current_user || @user.confirmed_friends?(current_user)
        redirect_to root_url, notice: "You're not friends with #{@user.name}."
      end
    end
end
