require 'test_helper'

class SiteLayoutTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  
  def setup
    @user   = users(:RealPerson)
    @friend = users(:WrongPerson)
    @posts  = @user.posts.all
    @post   = @friend.posts.first
  end
  
  test "header links" do
    # A non-logged in user can only view log in or sign up in their header.
    get root_path
    assert_select "a[href=?]", root_path
    assert_select "a[href=?]", new_user_registration_path
    assert_select "a[href=?]", new_user_session_path
    # A logged-in user, however, has a lot more options.
    sign_in @user
    get root_path
    assert_select 'a[href=?]',        friends_user_path(@user), text: "Friends"
    assert_select 'a[href=?]',         albums_user_path(@user), text: "Albums"
    assert_select 'a[href=?]', followed_pages_user_path(@user), text: "Pages"
    assert_select 'a[href=?]',  joined_groups_user_path(@user), text: "Groups"
    assert_select 'a[href=?]',            direct_messages_path, text: "Direct Messages"
  end
  
  test "user profiles display correctly" do
    sign_in @user
    get user_path(@user)
    # Basic user information is shown in a user's profile.
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
    
    @album = Album.create( user:        @friend,
                           title:       "book of photos",
                           description: "these are pictures" )
    
    @photo = Photo.create( photo_attachable: @album,
                           title:            "new pic",
                           description:      "spring break",
                           photo_data:       "picture" )
    
    # If you try to view a user's profile, photos, albums, posts, or edit or delete albums
    #     without permission, you'll be booted back to your home page.
    get user_path(@friend)
    assert_redirected_to root_url
    get photo_path(@photo)
    assert_redirected_to root_url
    get album_path(@album)
    assert_redirected_to root_url
    get edit_album_path(@album)
    assert_redirected_to root_url
    patch album_path(@album)
    assert_redirected_to root_url
    delete album_path(@album)
    assert_redirected_to root_url
    get post_path(@post)
    assert_redirected_to root_url
    
    @user.send_friend_request(@friend)
    @friendship = Friendship.find_by(user: @user, friend: @friend)
    sign_in @friend
    patch friendship_path(@friendship), params: { commit: "Accept" }
    
    # However, if you're friends with a user, you can check out ALL their stuff.
    sign_in @user
    # their Photos,
    get photo_path(@photo)
    assert_select 'p.title',     text: @photo.title
    assert_select 'div.content', text: @photo.description
    # their Albums,
    get albums_user_path(@friend)
    assert_select 'p.title',       text: "#{@friend.name}'s Albums"
    assert_select 'div.title',     text: @album.title
    assert_select 'div.subtitle',  text: @album.description
    assert_select 'a[href=?]',            album_path(@album)
    get album_path(@album)
    assert_select 'div.title',     text: @album.title
    assert_select 'div.subtitle',  text: @album.description
    assert_select 'div.subtitle',  text: "by #{@friend.name}"
    # their Posts,
    get post_path(@post)
    assert_select 'div.post-content', text: @post.content
    assert_select 'small',            text: "#{time_ago_in_words(@post.created_at)} ago"
    assert_select 'strong',           text: @friend.name
    # their card items,
    get user_path(@friend)
    assert_select 'span.subtitle',                         text: "Message"
    assert_select 'a[href=?]', friends_user_path(@friend), text: "Friends"
    assert_select 'div#friend_request_form'
    # or your own card items.
    get user_path(@user)
    assert_select 'span.subtitle',                         text: "My Posts"
    assert_select 'a[href=?]', friends_user_path(@user),   text: "Friends"
    
    # You can even edit, update or delete albums if you're logged in.
    sign_in @friend
    get edit_album_path(@album)
    # edit form
    # patch album_path(@album)
    # goes through
    delete album_path(@album)
    # goes through
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
