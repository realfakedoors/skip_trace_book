require 'test_helper'

class PostingPostsTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  
  def setup
    @user = users(:RealPerson)
  end
  
  test "interacting with posts" do
    sign_in @user
    get root_path
    assert_select "div.field"
    assert_select "input[type=file]"
    # Reject a post with blank content.
    assert_no_difference 'Post.count' do
      post posts_path, params: { post: { content: ""} }
    end
    # Accept a valid post.
    content = "This post is awesome!"
    picture = fixture_file_upload('test/fixtures/files/rails.png', 'image/png')
    assert_difference 'Post.count', 1 do
      post posts_path, params: { post: { postable_id: @user.id,
                                       postable_type: "User",
                                             content: content,
                                             picture: picture   } }
    end
    assert_redirected_to root_url
    follow_redirect!
    most_recent_post = @user.posts.first
    assert_match content, most_recent_post.content
    # Delete a post.
    assert_select 'a', text: "Delete"
    assert_difference 'Post.count', -1 do
      delete post_path(most_recent_post)
    end
    # Visit a different user's post with no Delete button.
    get user_path(users(:WrongPerson))
    assert_select 'a', text: "Delete", count: 0
  end
end
