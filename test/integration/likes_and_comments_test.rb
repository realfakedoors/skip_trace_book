require 'test_helper'

class LikesAndCommentsTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  
  def setup
    @user               = users(:RealPerson)
    @friend             = users(:WrongPerson)
    
    @page               = pages(:Redman)
    @photo              = photos(:Mario)
    @group              = groups(:Ballers)
    @user_post          = posts(:freeeeeeee)
    @friend_post        = posts(:cudi_montage)
    @direct_message     = messages(:direct_message)
    @discussion_message = messages(:discussion_message)
  end
  
  test "A logged-in user can like a variety of content" do
    sign_in(@user)
    
    # A user's own posts or their friends' posts,
    get post_path(@user_post)
    assert_difference 'Like.count', 2 do
      @friend_post.likes.build(user: @user).save
        @user_post.likes.build(user: @user).save
    end
    
    # Any page's posts,
    get page_path(@page)
    post = @page.posts.build(content: "Part II")
    assert post.valid?
    post.save
    
    assert_difference 'Like.count', 1 do
      post.likes.build(user: @user).save
    end
    
    # A user's joined group's messages OR their own DMs,
    get group_path(@group)
    assert_difference 'Like.count', 2 do
      @discussion_message.likes.build(user: @user).save
          @direct_message.likes.build(user: @user).save
    end
    
    # Any comments,
    get photo_path(@photo)
    comment = @photo.comments.build(content: "awesome photo!", user: @user)
    assert comment.valid?
    comment.save
    
    assert_difference 'Like.count', 1 do
      comment.likes.build(user: @user).save
    end
    
    # A user's own photos, their friends' photos, or their joined groups' photos.
    assert_difference 'Like.count', 1 do
      @photo.likes.build(user: @user).save
    end
    
    friend_photo = @friend.albums.new.photos.build(photo_data: "bulletbill.jpg", 
                                                        title: "sick pic", 
                                                  description: "this is the coolest photo ever")
    assert friend_photo.valid?
    friend_photo.save
    
    group_photo  =  @group.photos.build(photo_data: "thwomp.jpg", 
                                             title: "watch your head", 
                                       description: "a spiky rectangular angry guy")
    assert group_photo.valid?
    group_photo.save
    
    assert_difference 'Like.count', 2 do
      friend_photo.likes.build(user: @user).save
       group_photo.likes.build(user: @user).save
    end 
  end
  
  test "A user can comment on a variety of content" do
    sign_in(@user)
    
    # A user can comment on a friend's posts,
    get post_path(@friend_post)
    assert_difference 'Comment.count', 1 do
      @friend_post.comments.build(user: @user, content: "nice post!").save
    end
    
    # Their own posts,
    get post_path(@user_post)
    assert_difference 'Comment.count', 1 do
      @user_post.comments.build(user: @user, content: "I have nice posts too!").save
    end   
     
    # Or any page's posts.
    page_post = @page.posts.build(content: "Neat stuff is cool!")
    assert page_post.valid?
    page_post.save
    
    assert_difference 'Comment.count', 1 do
      page_post.comments.build(user: @user, content: "this page has nice posts!").save
    end
    
    # A user can leave a comment on their own photos,
    get photo_path(@photo)
    assert_difference 'Comment.count', 1 do
      @photo.comments.build(user: @user, content: "i take nice photos!").save
    end
    
    # Their friends' photos,
    friend_photo = @friend.albums.new.photos.build(photo_data: "montymole.jpg", 
                                                        title: "diggin' guy", 
                                                  description: "this dude ain't scary!")
    assert friend_photo.valid?
    friend_photo.save
    
    assert_difference 'Comment.count', 1 do
      friend_photo.comments.build(user: @user, content: "nice shot!").save
    end    
    
    # Or their groups' photos.
    group_photo = @group.photos.build(photo_data: "charginchuck.jpg", 
                                           title: "football guy", 
                                     description: "a runny, chargy, tackly guy!")
    assert group_photo.valid?
    group_photo.save
    
    assert_difference 'Comment.count', 1 do
      group_photo.comments.build(user: @user, content: "stomp on his helmet!").save
    end   
  end  
end