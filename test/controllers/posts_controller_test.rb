require 'test_helper'

class PostsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  
  def setup
    @wrong_post = posts(:cudi_montage)
    @post = posts(:fire)
    @wrong_user = users(:WrongPerson)
    @user = users(:RealPerson)
  end
  
  test "only a logged-in user can create or destroy posts" do
    # Redirect create
    assert_no_difference 'Post.count' do
      post posts_path, params: { post: { content: "I'm not logged in yet!" } }
    end
    assert_redirected_to new_user_session_url
    # Redirect destroy
    assert_no_difference 'Post.count' do
      delete post_path(@post)
    end
    assert_redirected_to new_user_session_url
    # After a user signs in, they can create or destroy posts successfully.
    sign_in @user
    assert_difference 'Post.count', 1 do
      post posts_path, params: { post: { content: "Now I'm actually logged in!", user: @user } }
    end
    assert_difference 'Post.count', -1 do
      delete post_path(@post)
    end
    # However, they shouldn't be able to destroy other users' posts.
    assert @wrong_post.user == @wrong_user
    assert_no_difference 'Post.count' do
      delete post_path(@wrong_post)
    end
    assert_redirected_to root_url
  end
end
