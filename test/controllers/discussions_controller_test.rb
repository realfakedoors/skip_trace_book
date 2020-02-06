require 'test_helper'

class DiscussionsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  
  setup do
    @user       =       users(:WrongPerson)
    @group      =      groups(:Ballers)
    @discussion = discussions(:StanleyCup)
    
    sign_in @user
    @group.memberships.new(user: @user, group: @group, confirmed: true).save
  end
  
  test "should get new" do
    get new_discussion_url, params: { discussion: { group_id: @group.id }}
    assert_response :success
  end
  
  test "should create a discussion" do
    assert_difference('Discussion.count') do
      post discussions_url, params: { discussion: { group_id: @group.id,
                                                       title: "dang" }}
    end
    assert_redirected_to Discussion.last
  end

  test "should get show" do
    get discussion_url(@discussion), params: { discussion: { group_id: @group.id }}
    assert_response :success
  end

  test "should destroy a discussion successfully" do
    delete discussion_url(@discussion), params: { discussion: { group_id: @group.id }}
    assert_redirected_to root_url
  end

end
