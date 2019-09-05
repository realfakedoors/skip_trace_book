require 'test_helper'

class SiteLayoutTest < ActionDispatch::IntegrationTest
  
  test "header links" do
    get root_path
    assert_select "a[href=?]", root_path
    assert_select "a[href=?]", help_path
    assert_select "a[href=?]", about_path
    assert_select "a[href=?]", contact_path
    assert_select "a[href=?]", signup_path
  end
end
