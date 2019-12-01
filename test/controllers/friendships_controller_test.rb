require 'test_helper'

class FriendshipsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  
  setup do
    @user =   users(:RealPerson)
    @friend = users(:WrongPerson)
  end
  
  test "inverse friendship behavior" do
    #create an inverse friendship after a user accepts a friend request.
    @user.send_friend_request(@friend)
    @friendship = Friendship.find_by(user: @user, friend: @friend)
    
    sign_in @friend
    patch friendship_path(@friendship), params: { commit: "Accept" }
    
    @inverse_friendship = Friendship.find_by(user: @friend, friend: @user)
    assert @inverse_friendship.accepted?
    
    #destroy an inverse friendship if a user unfriends another user.
    @friendship.destroy
    assert_raise(ActiveRecord::RecordNotFound) { @friendship.reload }
    assert_raise(ActiveRecord::RecordNotFound) { @inverse_friendship.reload }
  end
end
