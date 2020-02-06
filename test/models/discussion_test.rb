require 'test_helper'

class DiscussionTest < ActiveSupport::TestCase

  def setup
    @discussion = discussions(:StanleyCup)
         @group = groups(:Ballers)
       @message = messages(:discussion_message)
  end
  
  test "Must have a group_id." do
    @discussion.group_id = nil
    assert @discussion.invalid?
  end
  
  test "has a message" do
    assert_not_nil @discussion.messages
  end
  
  test "if a Discussion is destroyed, its messages should also be destroyed" do
    @discussion.destroy
    assert_raise(ActiveRecord::RecordNotFound) { @message.reload }
  end

end
