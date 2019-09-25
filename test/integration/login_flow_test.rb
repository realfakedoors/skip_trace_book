require 'test_helper'

class LoginFlowTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  
  def setup
    @user         = users(:RealPerson)
    @invalid_user = users(:InvalidLoginPerson)
  end
  
  test "only a signed-in user can view the user index or edit their profile" do
    sign_in(@user)
    get users_path
    assert_response :success
    get edit_user_registration_path
    assert_response :success
    
    sign_out(@user)
    get users_path
    assert_response :redirect
    get edit_user_registration_path
    assert_response :redirect
  end
  
  test "an invalid user can't log in" do
    sign_in(@invalid_user)
    get users_path
    assert_response :redirect
    assert_not flash.empty?
    assert_not @invalid_user.valid?
  end
  
  test "login with remembering" do
    sign_in(@user)
    @user.remember_me!
    assert @user.remember_created_at
  end
  
  test "login without remembering" do
    # Log in to set the cookie.
    sign_in(@user)
    @user.remember_me!
    assert @user.remember_created_at
    # Log in again and verify that the cookie is deleted.
    @user.forget_me!
    assert_nil @user.remember_created_at
  end
  
end
