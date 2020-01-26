require 'test_helper'

class InteractingWithPagesTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  
  def setup
    @neophyte = users(:WrongPerson)
        @user = users(:RealPerson)
        @page = pages(:WuTangClan)
  end
  
  test "pages display and behave correctly" do
    sign_in(@user)
    @user.follow(@page)
    
    # General page information.
    get page_path(@page)
    assert_response :success
    assert_select "h1", text: @page.name
    assert_select "h6", text: @page.description
    assert_select "h6", text: "Location: #{@page.location}"
    assert_select "a",  text: @page.website
    assert_select "h6", text: @page.mission
    assert_select "h6", text: "Followers: #{@page.followers.count}"
    
    # Pages utilize a follow/unfollow button.
    assert_select "div", value: "Unfollow Page"
    following = Following.find_by(user: @user, page: @page)
    delete following_path(following)
    follow_redirect!
    assert_select "div", value: "Follow Page"
    post followings_path, params: { following: { user_id: @user.id,
                                                 page_id: @page.id  } }
    follow_redirect!
    assert_select "div", value: "Unfollow Page"
    
    # An admin can create posts,
    assert_equal @page.admin, @user
    assert_difference 'Post.count', 1 do
      post posts_path, params: { post: { postable_id: @page.id,
                                       postable_type: "Page",
                                             content: "HEY GUYS" } }
    end
    # add photos,
    new_photo = fixture_file_upload('test/fixtures/files/rails.png', 'image/png')
    assert_difference '@page.photos.count', 1 do
      post photos_path, params: { photo: { photo_attachable_id: @page.id,
                                         photo_attachable_type: "Page", 
                                                    photo_data: new_photo } }
    end
    # even delete a page.
    assert_difference 'Page.count', -1 do
      delete page_path(@page)
    end
    
    # A user can only look at a page's photos if they're an admin or a follower.
    @page  = pages(:Redman)
    @photo = @page.photos.new(photo_attachable: @page, photo_data: new_photo)
    @photo.save
    
    sign_in(@neophyte)
    assert_redirected_to pages_url do
      get photo_path(@photo)
    end
    sign_in(@user)
    # Hitting the X button on a photo's modal takes you back to the previous page.
    get photo_path(@photo)
    assert_redirected_to root_url do
      find('button.modal_close').click
    end
    # All pages index.
    get pages_path
    assert_select     "a.title", text: @page.name
    assert_select "h6.subtitle", text: @page.description
    # A user's followed pages index.
    @user.follow(@page)
    get followed_pages_user_path(@user)
    assert_select     "a.title", text: @page.name
    assert_select "h6.subtitle", text: @page.description
  end
  
end