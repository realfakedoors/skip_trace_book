require 'test_helper'

class PostTest < ActiveSupport::TestCase

  def setup
    @user =       users(:RealPerson)
    @post = @user.posts.build(content: "What up losers")
  end
  
  test "should be valid" do
    assert @post.valid?
  end
  
  test "user id should be present" do
    @post.user_id = nil
    assert_not @post.valid?
  end
  
  test "content should be present" do
    @post.content = "   "
    assert_not @post.valid?
  end
  
  test "content should be 280 characters or less" do
    @post.content = "q" * 280
    assert @post.valid?
    @post.content << "x"
    assert_not @post.valid?
  end
  
  test "posts should be sorted with the newest post first" do
    assert_equal posts(:most_recent), Post.first
  end
end
