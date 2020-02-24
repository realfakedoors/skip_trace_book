require 'test_helper'

class LikesControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @user = users(:RealPerson)
    @like = likes(:RealPersonLikesPost)
    
    sign_in @user
  end
  
  test "Users can destroy their likes" do
    assert_difference('Like.count', -1) do
      delete like_url(@like)
    end
  end
end
