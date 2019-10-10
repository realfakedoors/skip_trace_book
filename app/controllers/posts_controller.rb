class PostsController < ApplicationController
  before_action :correct_user, only: :destroy
  
  def create
    @post = current_user.posts.build(post_params)
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
    @post   = Post.find(params[:id])
    @author = @post.user
  end
    
  def destroy
    @post = Post.find(params[:id])
    @post.destroy
    flash[:success] = "Post deleted"
    redirect_to root_url
  end
  
  private
  
    def post_params
      params.require(:post).permit(:content, :picture)
    end
    
    def correct_user
      @post = current_user.posts.find_by(id: params[:id])
      redirect_to root_url if @post.nil?
    end
end
