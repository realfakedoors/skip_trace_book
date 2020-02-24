class LikesController < ApplicationController
  def create
    @like = Like.new(like_params)
    @like.user = current_user
    if @like.save
      redirect_back fallback_location: root_url
    else
      redirect_to root_url, notice: "You can't like that!"
    end
  end

  def destroy
    @like = Like.find(params[:id])
    @like.destroy
    redirect_back fallback_location: root_url
  end
  
  private
  
    def like_params
      params.require(:like).permit(:likable_id, :likable_type)
    end
end
