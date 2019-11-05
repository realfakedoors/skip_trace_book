require 'test_helper'

class SiteLayoutTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  
  def setup
    @user  = users(:RealPerson)
    @posts = @user.posts.all
  end
  
  test "header links" do
    get root_path
    assert_select "a[href=?]", root_path
    assert_select "a[href=?]", new_user_registration_path
    assert_select "a[href=?]", new_user_session_path
    
    sign_in @user
    get root_path
    assert_select 'a[href=?]', '#', text: "Friends"
    assert_select 'a[href=?]', '#', text: "Pages"
    assert_select 'a[href=?]', '#', text: "Groups"
    assert_select 'a[href=?]', '#', text: "Messages"
    assert_select 'a[href=?]', '#', text: "My Posts"
  end
  
  test "user profiles display correctly" do
    sign_in @user
    
    get user_path(@user)
    # Basic user information is shown.
    assert_select 'title', full_title(@user.name)
    assert_select 'h1', text: @user.name
    assert_select 'h2', text: @user.email
    assert_match  @user.posts.count.to_s, response.body
    # A user's post feed displays correctly.
    assert_select 'nav.pagination'
    @posts.paginate(page: 1, per_page: 10).each do |post|
      assert_select 'div.post-content',    text: post.content
      assert_select 'small',               text: "#{time_ago_in_words(post.created_at)} ago"
    end
    # A user's friend list displays correctly.
    @friend = users(:WrongPerson)
    @user.send_friend_request(@friend)
    @friend.accept_friend_request(Friendship.find_by(user: @user, friend: @friend))
    get friends_user_path(@user)
    assert_select    'p.title', text: @friend.name
    assert_select 'p.subtitle', text: @friend.email
  end
end
