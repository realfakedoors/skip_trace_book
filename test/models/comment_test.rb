require 'test_helper'

class CommentTest < ActiveSupport::TestCase

  def setup
    @user    =    users(:RealPerson)
    
    @photo   =   photos(:Mario)
    @post    =    posts(:freeeeeeee)
    
    @comment = comments(:RealPersonCommentsOnFire)
  end
  
  test "A comment has to belong_to either a photo or a post" do
    photo_comment = Comment.new(commentable_id: @photo.id,
                              commentable_type: "Photo",
                                          user: @user,
                                       content: "nice photo!")
    assert photo_comment.valid?
    
    post_comment = Comment.new(commentable_id: @post.id,
                             commentable_type: "Post",
                                         user: @user,
                                      content: "nice post!")
    assert post_comment.valid?
  end
  
  test "A comment's content can be between 5 and 200 characters" do
    @comment.content = ""
    assert_not @comment.valid?
    
    @comment.content = "x" * 201
    assert_not @comment.valid?
  end
  
  test "A comment has to belong_to a user" do
    @comment.user = nil
    assert_not @comment.valid?
  end
  
  test "If a user is destroyed, their comments are destroyed as well" do
    @user.destroy
    assert_raise(ActiveRecord::RecordNotFound) { @comment.reload }
  end
end