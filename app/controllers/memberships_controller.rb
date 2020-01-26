class MembershipsController < ApplicationController
  before_action :set_group
  before_action :set_user
  before_action :correct_user, only: [:update]
  
  def create
    @group.members << @user
    redirect_back fallback_location: root_url
  end
  
  def update
    @group.confirm(@user)
    redirect_back fallback_location: root_url
  end
  
  def destroy
    Membership.find_by(user: @user, group: @group).destroy
    redirect_back fallback_location: root_url
  end
  
  private
  
    def set_group
      @group = Group.find(params[:membership][:group_id])
    end
    
    def set_user
      @user = User.find(params[:membership][:user_id])
    end
    
    def correct_user
      unless current_user == @group.leader
        redirect_to root_url, notice: "You're not the leader of this group."
      end
    end
  
    def membership_params
      params.require(:membership).permit(:user_id, :group_id)
    end  
end
