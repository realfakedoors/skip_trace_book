require 'test_helper'

class DeviseMailerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  
  def setup
    @user = User.new(name: "Example User", email: "user@example.com", password: "password")
    @user.skip_confirmation_notification!
    @user.confirm
    @user.save
  end
  
  test "Devise mailer" do
    # confirmations and reset instructions get sent successfully.
    assert_empty Devise.mailer.deliveries
    assert_difference 'Devise.mailer.deliveries.count', 2 do
      @user.send_confirmation_instructions
      @user.send_reset_password_instructions
    end
    # email changed notifications get sent successfully.
    assert_difference 'Devise.mailer.deliveries.count', 1 do
      @user.email = "brand_new_email@npr.org"
      @user.save
    end
    # password changed notifications get sent successfully.
    assert_difference 'Devise.mailer.deliveries.count', 1 do
      @user.password = "new_pass"
      @user.save
    end
    # unlock instructions get sent successfully.
    assert_difference 'Devise.mailer.deliveries.count', 1 do
      @user.lock_access!
    end
  end  
end