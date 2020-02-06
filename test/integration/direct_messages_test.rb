require 'test_helper'

class DirectMessagesTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  
  def setup
         @initiator = users(:WrongPerson)
         @recipient = users(:RealPerson)
        @photo_data = fixture_file_upload('test/fixtures/files/rails.png', 'image/png')
    @direct_message = direct_messages(:dm)
           @message = messages(:direct_message)
  end
  
  test "direct message behavior" do
    sign_in(@recipient)
    
    # A user's DM index, or 'inbox'.
    get direct_messages_path
    assert_select "h1.title", text: "Direct Messages"
    assert_select "a.button", text: "Compose"
    assert_select "p",        text: @initiator.name
    assert_select "a",        text: @message.content
    assert_select "p",        text: time_ago_in_words(@message.created_at)
    
    # A user can create a new DM.
    assert_difference 'DirectMessage.count' do
      post direct_messages_path, params: { direct_message: {
        initiator_id: @recipient.id.to_i,
        recipient_id: @initiator.id.to_i
      }}
    end
    new_dm = DirectMessage.last
    
    # Create a new message within that DM,
    assert_difference 'Message.count' do
      post messages_path, params: { message: {
          messageable_id: new_dm.id,
        messageable_type: "DirectMessage",
                 content: "whassup"
      }}
    end
    
    # Then visit that DM.
    get direct_message_path(new_dm)
    assert_select "h1.title", text: @initiator.name
    assert_select "h7",       text: @recipient.name
    assert_select "h6",       text: "whassup"
  end
end
