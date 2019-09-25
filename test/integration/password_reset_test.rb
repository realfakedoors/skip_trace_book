require 'test_helper'

class PasswordResetTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  
  def setup
    @user = users(:RealPerson)
  end
  
  test "accept valid password changes" do
    old_pw = @user.encrypted_password
    @user.reset_password("valid_pw_12345", "valid_pw_12345")
    assert_not_equal @user.encrypted_password, old_pw
  end
  
  test "reject invalid password changes" do
    old_pw = @user.encrypted_password
    @user.reset_password(nil, nil)
    assert_equal @user.encrypted_password, old_pw
  end
  
  test "reject expired reset tokens" do
    @user.send_reset_password_instructions
    travel_to Time.now + 7.hours
    assert_not @user.reset_password_period_valid?
  end
end