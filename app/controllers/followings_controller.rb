class FollowingsController < ApplicationController
    
  def create
    @page = Page.find(params[:following][:page_id])
    current_user.follow(@page)
    redirect_back fallback_location: root_url
  end

  def destroy
    @following = Following.find(params[:id])
    @following.delete
    redirect_back fallback_location: root_url
  end
  
  private

    def following_params
      params.require(:following).permit(:page_id)
    end
end
