class FriendshipsController < ApplicationController
  
  def create
    user = User.find(params[:friend_id])
    current_user.send_friend_request(user)
    redirect_back fallback_location: root_url
  end
  
  def update
    friendship = Friendship.find(params[:id])
    commit = params[:commit]
    if commit == "Accept"
      friendship.accepted = true
      friendship.save
    elsif commit == "Decline"
      friendship.destroy
    end
    redirect_back fallback_location: root_url
  end
  
  def destroy
    user = Friendship.find(params[:id]).friend
    current_user.unfriend(user)
    user.unfriend(current_user)
    redirect_back fallback_location: root_url
  end
  
end