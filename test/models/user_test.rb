require 'test_helper'

class UserTest < ActiveSupport::TestCase
  
  def setup
    @user = User.new(name: "Brand New User", email: "brandnewuser@skiptracebook.com",
                     encrypted_password: "foobar"
                     )
    @friend = users(:RealPerson)
    @buddy  = users(:WrongPerson)
    @page   = pages(:WuTangClan)
  end
  
  test "should be valid" do
    assert @user.valid?
  end
  
  test "name should be present" do
    @user.name = "        "
    assert_not @user.valid?
  end
  
  test "email should be present" do
    @user.email = "         "
    assert_not @user.valid?
  end
  
  test "name should not be too long" do
    @user.name = "a" * 51
    assert_not @user.valid?
  end
  
  test "email should not be too long" do
    @user.email = "a" * 244 + "@example.com"
    assert_not @user.valid?
  end
  
  test "email validation should accept valid addresses" do
    valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org first.last@foo.jp alice+bob@baz.cn]
    valid_addresses.each do |valid_address|
      @user.email = valid_address
      assert @user.valid?#, "#{valid_address.inspect} isn't a valid email!"
    end
  end
  
  test "email validation should reject invalid addresses" do
    invalid_addresses = %w[user@example,com user_at_foo.org user.name@example. foo@bar_baz.com foo@bar+baz.com foo@bar..com]
    invalid_addresses.each do |invalid_address|
      @user.email = invalid_address
      assert_not @user.valid?, "#{invalid_address.inspect} should be invalid!"
    end
  end
  
  test "email addresses should be unique" do
    duplicate_user = @user.dup
    duplicate_user.email = @user.email.upcase
    @user.save
    assert_not duplicate_user.valid?
  end
  
  test "if a user is destroyed, their posts should be destroyed" do
    @user.save
    @user.posts.create!(content: "I love coffee!")
    assert_difference 'Post.count', -1 do
      @user.destroy
    end
  end
  
  test "friend request functionality" do
    # a user can send a friend request to another user.
    @friend.send_friend_request(@buddy)
    assert @friend.friend_request_sent?(@buddy)
    friendship = Friendship.find_by(user: @friend, friend: @buddy)
    assert_not_nil friendship
    assert @friend.friend_request_sent?(@buddy)
    # a user can accept another user's friend request.
    @buddy.accept_friend_request(friendship)
    assert friendship.accepted?
    # a user can unfriend another user.
    assert_difference 'Friendship.count', -1 do
      @friend.unfriend(@buddy)
    end
  end
  
  test "a user can be the administrator of a page" do
    assert_equal @page.admin, @friend
  end
end
