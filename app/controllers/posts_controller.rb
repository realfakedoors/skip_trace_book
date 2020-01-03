class PostsController < ApplicationController
  before_action :correct_user,         only: :destroy
  before_action :check_for_friendship, only: :show
  
  def create
    @post  = current_user.posts.build(post_params)
    if @post.save
      flash[:success] = "Post created!"
      redirect_to root_url
    else
      @feed_items = []
      @post.errors.messages.each{ |msg| flash[:danger] = msg.last.last }
      redirect_to root_url
    end
  end
  
  def show
  end
    
  def destroy
    @post = Post.find(params[:id])
    @post.destroy
    flash[:success] = "Post deleted"
    redirect_to root_url
  end
  
  private
  
    def post_params
      params.require(:post).permit(:content, :photo, photo_attributes: [:photo_data])
    end
    
    def correct_user
      @post = Post.find(params[:id])
      if @post.user != current_user
        redirect_to root_url, notice: "Invalid user permissions!"
      end
    end
    
    def check_for_friendship
      @post   = Post.find(params[:id])
      @author = @post.user
      unless current_user == @author || @author.confirmed_friends?(current_user)
        redirect_to root_url, notice: "You're not friends with #{@author.name}."
      end
    end
end
