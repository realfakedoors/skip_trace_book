require 'test_helper'

class DirectMessageTest < ActiveSupport::TestCase
  
  def setup
    @initiator = users(:RealPerson)
    @recipient = users(:WrongPerson)
           @dm = direct_messages(:dm)
      @message = messages(:direct_message)
  end
  
  test "Must have an initiator_id." do
    @dm.initiator_id = nil
    assert @dm.invalid?
  end
  
  test "Must have a recipient_id." do
    @dm.recipient_id = nil
    assert @dm.invalid?
  end
  
  test "Has a message" do
    assert_not_nil @dm.messages
  end
  
  test "if a DirectMessage is destroyed, its messages should also be destroyed" do
    @dm.destroy
    assert_raise(ActiveRecord::RecordNotFound) { @message.reload }
  end
  
end
