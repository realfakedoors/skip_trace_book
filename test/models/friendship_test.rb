require 'test_helper'

class FriendshipTest < ActiveSupport::TestCase
  include Devise::Test::IntegrationHelpers
  
  def setup
    @user =   users(:RealPerson)
    @friend = users(:WrongPerson)
    @friendship = Friendship.new(user: @user, friend: @friend)
  end
  
  test "should be valid" do
    assert @friendship.valid?
  end
  
  test "should require a user id" do
    @friendship.user_id = nil
    assert_not @friendship.valid?
  end
  
  test "should require a friend id" do
    @friendship.friend_id = nil
    assert_not @friendship.valid?
  end
  
  test "a friendship begins in requested mode until it gets accepted" do
    @friendship.save
    assert     @friendship.requested?
    assert_not @friendship.friend_accepted?
    @friendship.accepted = true
    @friendship.save
    assert_not @friendship.requested?
    assert     @friendship.friend_accepted?
  end
  
  test "a friendship ceases to exist if one of its users is destroyed" do
    @friendship.save
    @user.destroy
    assert_raise(ActiveRecord::RecordNotFound) do
      @friendship.reload
    end
  end
end
