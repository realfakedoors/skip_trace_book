require 'test_helper'

class LoginFlowTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  
  def setup
    @user = users(:RealPerson)
    @page = pages(:WuTangClan)
  end
  
  test "a user can follow a page" do
    @page.followers << @user
    assert_includes @page.followers,      @user
    assert_includes @user.followed_pages, @page
    assert_includes Following.all,        Following.find_by(user: @user, page: @page)
  end
end