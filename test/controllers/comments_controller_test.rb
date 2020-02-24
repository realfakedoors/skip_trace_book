require 'test_helper'

class CommentsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @user    = users(:RealPerson)
    @comment = comments(:RealPersonCommentsOnFire)
    
    sign_in @user
  end
  
  test "Users can destroy their comments" do
    assert_difference('Comment.count', -1) do
      delete comment_url(@comment)
    end
  end
end
