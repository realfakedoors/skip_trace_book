require 'test_helper'

class LikeTest < ActiveSupport::TestCase
  
  def setup
    @user    = users(:RealPerson)
    
    @comment = comments(:RealPersonCommentsOnFire)
    @message = messages(:direct_message)
    @photo   =   photos(:Mario)
    @post    =    posts(:freeeeeeee)
    
    @like    =    likes(:RealPersonLikesPost)
  end
  
  test "A like has to belong_to a post, message, comment or a photo" do
    post_like = Like.new(likable_id: @post.id,
                       likable_type: "Post",
                               user: @user)
    assert post_like.valid?
    
    message_like = Like.new(likable_id: @message.id,
                          likable_type: "Message",
                                  user: @user)
    assert message_like.valid?
    
    comment_like = Like.new(likable_id: @comment.id,
                          likable_type: "Comment",
                                  user: @user)
    assert comment_like.valid?
    
    photo_like = Like.new(likable_id: @photo.id,
                        likable_type: "Photo",
                                user: @user)
    assert photo_like.valid?
  end
  
  test "A like has to belong_to a user" do
    @like.user = nil
    assert_not @like.valid?
  end
  
  test "If a user is destroyed, their likes are destroyed as well" do
    @user.destroy
    assert_raise(ActiveRecord::RecordNotFound) { @like.reload }
  end
end
