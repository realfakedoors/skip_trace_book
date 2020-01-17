require 'test_helper'

class FollowingsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  
  setup do
    @user = users(:RealPerson)
    @page = pages(:Redman)
  end
  
  test "a user can create a new following by following a page" do
    assert_difference 'Following.count' do
      @user.follow(@page)
    end
    # a user can also delete a following by unfollowing a page.
    assert_difference 'Following.count', -1 do
      @user.unfollow(@page)
    end
  end

end
