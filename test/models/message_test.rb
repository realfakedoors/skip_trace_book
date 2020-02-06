require 'test_helper'

class MessageTest < ActiveSupport::TestCase

  def setup
    @message = messages(:direct_message)
  end
  
  test "Must have a user_id." do
    @message.user_id = nil
    assert @message.invalid?
  end
  
  test "Must have a messageable_id." do
    @message.messageable_id = nil
    assert @message.invalid?
  end
  
  test "Must have a messageable_type." do
    @message.messageable_type = nil
    assert @message.invalid?
  end
  
  test "Content can't be more than 1000 characters." do
    @message.content = "Whoa" * 300
    assert @message.invalid?
  end
  
  test "Must have content." do
    @message.content = nil
    assert @message.invalid?
  end

end
