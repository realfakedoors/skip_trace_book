class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy, :friends]

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
    @title          = "#{@user.name}'s Friends"
    @friends        = @user.friends.paginate(page: params[:page], per_page: 12)
    @row_of_friends = @friends.each_slice(4)
    render 'show_friends'
  end

  private
    def set_user
      @user = User.find(params[:id])
    end

    def user_params
      params.require(:user).permit(:name, :email)
    end
end
