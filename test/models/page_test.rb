require 'test_helper'

class PageTest < ActiveSupport::TestCase
  
  def setup
    @user = users(:RealPerson)
    @page = pages(:WuTangClan)
  end
  
  test "Must have a user_id." do
    @page.user_id = nil
    assert @page.invalid?
  end
  
  test "Has to have a Name, and it can't be longer than 100 characters." do
    @page.name = nil
    assert @page.invalid?
    @page.name = "h" * 125
    assert @page.invalid?
  end
  
  test "Description can be 100 characters max." do
    @page.description = "h" * 125
    assert @page.invalid?
  end
  
  test "Same for Location." do
    @page.location = "h" * 125
    assert @page.invalid?
  end
  
  test "Website is only valid if it's a proper URL." do
    @page.website = "notareal.url"
    assert @page.invalid?
  end
  
  test "Mission Statement can't be longer than 500 characters." do
    @page.mission = "q" * 560
    assert @page.invalid?
  end
end
