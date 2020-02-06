require 'test_helper'

class DiscussionsTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  
  def setup
    @group      = groups(:Ballers)
    @user       = users(:RealPerson)
    @group.members << @user
    @group.confirm(@user)
    
    @discussion = discussions(:StanleyCup)
    @message    = messages(:discussion_message)
    @photo_data = fixture_file_upload('test/fixtures/files/rails.png', 'image/png')
  end
  
  test "discussion behavior" do
    sign_in(@user)
    
    # A group member can create a new discussion,
    get group_path(@group)
    assert_response :success
    assert_difference 'Discussion.count' do
      post discussions_path, params: { discussion: {
        group_id: @group.id,
           title: "Heck Yeah"
      }}
    end
    new_discussion = Discussion.last
    
    # Create a new message within that discussion,
    assert_difference 'Message.count' do
      post messages_path, params: { message: {
          messageable_id: new_discussion.id,
        messageable_type: "Discussion",
                 content: "DAAAAAANG"
      }}
    end
    # Then visit that discussion.
    get discussion_url(new_discussion)
    assert_response :success
    
    assert_select "h1.title", text: new_discussion.title
    assert_select "h6",       text: "DAAAAAANG"
  end
end
