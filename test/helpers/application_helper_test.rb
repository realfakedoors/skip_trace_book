require 'test_helper'

class ApplicationHelperTest < ActionView::TestCase
  test "full title helper" do
    assert_equal full_title(),           "SkipTraceBook"
    assert_equal full_title("About Us"), "About Us | SkipTraceBook"
  end
end