ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'
require "minitest/reporters"
Minitest::Reporters.use!

class ActiveSupport::TestCase
  fixtures :all
  include ApplicationHelper
  
end

class ActionDispatch::IntegrationTest
  def sign_in(user, password)
    post user_session_path \
      "user[email]" => user.email,
      "user[password]" => password
  end
end