class UsersController < ApplicationController
  before_action :set_user,   except: [:index, :new, :create, :received_friend_requests]

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
    @friends               = @accepted_friends.paginate(page: params[:page], per_page: 12)
    @row_of_friends        = @friends.each_slice(4)
    render 'show_friends'
  end
  
  def received_friend_requests
    @unanswered_friendships = Friendship.where(accepted: false).where(friend_id: current_user.id).to_a
                  @requests = @unanswered_friendships.paginate(page: params[:page], per_page: 8)
  end

  private
    def set_user
      @user = User.find(params[:id])
    end

    def user_params
      params.require(:user).permit(:name, :email)
    end
end
