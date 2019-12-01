require 'test_helper'

class SiteLayoutTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  
  def setup
    @user   = users(:RealPerson)
    @friend = users(:WrongPerson)
    @posts  = @user.posts.all
  end
  
  test "header links" do
    get root_path
    assert_select "a[href=?]", root_path
    assert_select "a[href=?]", new_user_registration_path
    assert_select "a[href=?]", new_user_session_path
    
    sign_in @user
    get root_path
    assert_select 'a[href=?]', friends_user_path(@user),        text: "Friends"
    assert_select 'a[href=?]', received_friend_requests_path,   text: "Friend Requests"
    assert_select 'a[href=?]', '#', text: "Pages"
    assert_select 'a[href=?]', '#', text: "Groups"
    assert_select 'a[href=?]', '#', text: "Messages"
    assert_select 'a[href=?]', '#', text: "My Posts"
  end
  
  test "user profiles display correctly" do
    sign_in @user
    
    get user_path(@user)
    # Basic user information is shown.
    assert_select      'title',     full_title(@user.name)
    assert_select    'p.title',     text: @user.name
    assert_select 'p.subtitle',     text: @user.email
    assert_select 'span.is-size-5', text: @user.occupation
    assert_select 'span.is-size-5', text: @user.company
    assert_select 'span.is-size-5', text: @user.location
    assert_select 'span.is-size-5', text: @user.birthday.strftime("%m/%d/%Y")
    
    # A user's post feed displays correctly.
    assert_select 'nav.pagination'
    @posts.paginate(page: 1, per_page: 10).each do |post|
      assert_select 'div.post-content',    text: post.content
      assert_select 'small',               text: "#{time_ago_in_words(post.created_at)} ago"
    end
    
    # A user's profile, photos, albums, posts and card footer items display correctly.
    get user_path(@friend)
    assert_redirected_to root_url
    
    @album = Album.create( user:        @friend,
                           title:       "book of photos",
                           description: "these are pictures" )
    
    @photo = Photo.create( album:       @album,
                           title:       "new pic",
                           description: "spring break",
                           photo_data:  "picture" )
    
    get photo_path(@photo)
    assert_redirected_to root_url
    get album_path(@album)
    assert_redirected_to root_url
    get post_path(@friend.posts.first)
    assert_redirected_to root_url
    
    sign_in @user
    @user.send_friend_request(@friend)
    @friendship = Friendship.find_by(user: @user, friend: @friend)
    
    sign_in @friend
    patch friendship_path(@friendship), params: { commit: "Accept" }
    
    sign_in @user
    get user_path(@friend)
    assert_select 'span.subtitle',                         text: "Message"
    assert_select 'a[href=?]', friends_user_path(@friend), text: "Friends"
    assert_select 'div#friend_request_form'
    get user_path(@user)
    assert_select 'span.subtitle',                         text: "My Posts"
    assert_select 'a[href=?]', friends_user_path(@user),   text: "Friends"
    
    
    
  end
    
  test "A user can send, approve and decline friend requests correctly" do
    @user.send_friend_request(@friend)
    @friendship = Friendship.find_by(user: @user, friend: @friend)
    
    sign_in @friend
    patch friendship_path(@friendship), params: { commit: "Accept" }
    get   friends_user_path(@friend)
    assert_select    'p.title', text: @user.name
    assert_select 'p.subtitle', text: @user.email
    
    patch friendship_path(@friendship), params: { commit: "Decline" }
    assert_raise(ActiveRecord::RecordNotFound) { @friendship.reload }
    
  end
    
  test "A user's friend requests and friends display correctly" do
    @friend.send_friend_request(@user)
    sign_in @user
    get received_friend_requests_path
    assert_select    'p.title', text: @friend.name
    
    @friendship = Friendship.find_by(user: @friend, friend: @user)
    sign_in @friend
    patch friendship_path(@friendship), params: { commit: "Accept" }
    get friends_user_path(@user)
    assert_select    'p.title', text: @friend.name
  end
end
