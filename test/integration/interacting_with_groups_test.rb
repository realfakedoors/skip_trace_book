require 'test_helper'

class InteractingWithGroupsTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  
  def setup
      @neophyte = users(:WrongPerson)
          @user = users(:RealPerson)
         @group = groups(:Ballers)
    @discussion = discussions(:StanleyCup)
    @photo_data = fixture_file_upload('test/fixtures/files/rails.png', 'image/png')
  end
  
  test "groups display and behave correctly" do
    sign_in(@user)
    @group.memberships.build(user: @user, confirmed: true).save
    
    # General group information.
    get group_path(@group)
    assert_response :success
    assert_select "h1",       text: @group.name
    assert_select "h6",       text: @group.description
    assert_select "h6",       text: "Objective: #{@group.objective}"
    assert_select "button",   text: "Members (#{@group.confirmed_members.count})"
    assert_select "h3.title", text: "Discussions"
    assert_select "a",        text: @discussion.title
    assert_select "p",        text: @discussion.messages.last.content
    
    # All groups index.
    get groups_path
    assert_select "a.title",     text: @group.name
    assert_select "h6.subtitle", text: @group.description
    
    # A user's group index.
    get joined_groups_user_path(@user)
    assert_select "a.title",     text: @group.name
    assert_select "h6.subtitle", text: @group.description
    
    # A group leader can create posts,
    assert_equal @group.leader, @user
    assert_difference 'Post.count', 1 do
      post posts_path, params: { post: { postable_id: @group.id,
                                       postable_type: "Group",
                                             content: "HEY GUYS" } }
    end
    # add photos,
    assert_difference '@group.photos.count', 1 do
      post photos_path, params: { photo: { photo_attachable_id: @group.id,
                                         photo_attachable_type: "Group", 
                                                    photo_data: @photo_data } }
    end
    # even delete a group.
    assert_difference 'Group.count', -1 do
      delete group_path(@group)
    end  
  end
  
end