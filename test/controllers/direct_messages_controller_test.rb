require 'test_helper'

class DirectMessagesControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  
  setup do
    @initiator      =           users(:WrongPerson)
    @recipient      =           users(:RealPerson)
    @direct_message = direct_messages(:dm)
    
    sign_in @initiator
  end
  test "should get new" do
    get new_direct_message_url
    assert_response :success
  end
  
  test "should create a direct message" do
    assert_difference('DirectMessage.count') do
      post direct_messages_url, params: { direct_message: { initiator_id: @initiator.id,
                                                            recipient_id: @recipient.id  } }
    end
    assert_redirected_to DirectMessage.last
  end

  test "should get show" do
    get direct_message_url(@direct_message)
    assert_response :success
  end

  test "should get index" do
    get direct_messages_url
    assert_response :success
  end

  test "should destroy a direct message successfully" do
    delete direct_message_url(@direct_message)
    assert_redirected_to root_url
  end

end
