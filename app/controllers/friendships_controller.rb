class FriendshipsController < ApplicationController
  
  def create
    user = User.find(params[:friend_id])
    current_user.send_friend_request(user)
    refresh_page
  end
  
  def update
    friendship = Friendship.find(params[:id])
    commit = params[:commit]
    if commit == "Accept"
      friendship.accepted = true
      friendship.save
      friendship.create_inverse_friendship
    elsif commit == "Decline"
      friendship.destroy
    end
    refresh_page
  end
  
  def destroy
    user = Friendship.find(params[:id]).friend
    current_user.unfriend(user)
    refresh_page
  end
  
  private
  
    def refresh_page
      redirect_back fallback_location: root_url
    end
end
