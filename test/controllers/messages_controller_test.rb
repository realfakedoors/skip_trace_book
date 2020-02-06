require 'test_helper'

class MessagesControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @user       =       users(:WrongPerson)
    @group      =      groups(:Ballers)
    @discussion = discussions(:StanleyCup)
    @message    =    messages(:discussion_message)
    
    sign_in @user
    
    @group.memberships.new(user: @user, group: @group, confirmed: true).save
  end
  
  test "should create message" do
    assert_difference 'Message.count', 1 do
      post messages_path, params: { message: { user_id: @user.id,
                                               content: "Hell yeah brother",
                                        messageable_id: @discussion.id,
                                      messageable_type: "Discussion" } }
    end
  end

  test "should destroy successfully" do
    assert_difference 'Message.count', -1 do
      delete message_path(@message)
    end
  end
end
