require 'test_helper'

class GroupTest < ActiveSupport::TestCase
  
  def setup
    @user = users(:RealPerson)
    @group = groups(:Ballers)
  end
  
  test "Must have a user_id." do
    @group.user_id = nil
    assert @group.invalid?
  end
  
  test "Has to have a Name, and it can't be longer than 100 characters." do
    @group.name = nil
    assert @group.invalid?
    @group.name = "h" * 125
    assert @group.invalid?
  end
  
  test "Description can be 100 characters max." do
    @group.description = "h" * 125
    assert @group.invalid?
  end
  
  test "Objective can be 500 characters max." do
    @group.objective = "h" * 525
    assert @group.invalid?
  end
  
end
