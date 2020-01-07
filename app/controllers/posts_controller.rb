class PostsController < ApplicationController
  before_action :correct_user,         only: :destroy
  before_action :check_for_friendship, only: :show
  
  def create
    @post  = Post.new(post_params)
    if @post.save
      redirect_back fallback_location: root_url, notice: "Post created!"
    else
      @feed_items = []
      @post.errors.messages.each{ |msg| flash[:danger] = msg }
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
      params.require(:post).permit(:content, 
                                     :photo,
                               :postable_id,
                             :postable_type,      
            photo_attributes: [:photo_data])
    end
    
    def correct_user
      @post = Post.find(params[:id])
      if @post.postable != current_user
        redirect_to root_url, notice: "Can't delete other people's posts!"
      end
    end
    
    def check_for_friendship
      @post   = Post.find(params[:id])
      @author = @post.postable
      unless current_user == @author || @author.confirmed_friends?(current_user)
        redirect_to root_url, notice: "You're not friends with #{@author.name}."
      end
    end
end
