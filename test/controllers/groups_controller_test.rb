require 'test_helper'

class GroupsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  
  setup do
    @group = groups(:Ballers)
    @user  = users(:RealPerson)
    sign_in @user
  end

  test "should get index" do
    get groups_url
    assert_response :success
  end

  test "should get new" do
    get new_group_url
    assert_response :success
  end
  
  test "should get members" do
    get members_group_path(@group)
    assert_response :success
  end

  test "should create group" do
    assert_difference('Group.count') do
      post groups_url, params: { group: { name: 'Cucumber Squad',
                                   description: 'we always find ourselves in a pickle',
                                     objective: 'to sit in a jar full of vinegar for 24 hours',
                                       user_id: @user.id } }
    end

    assert_redirected_to group_url(Group.last)
  end

  test "should show group" do
    get group_url(@group)
    assert_response :success
  end

  test "should get edit" do
    get edit_group_url(@group)
    assert_response :success
  end

  test "should update group" do
    patch group_url(@group), params: { group: { name: 'Straight Bangerz',
                                         description: 'never mind the off-brand stuff',
                                           objective: 'we invented originality',
                                             user_id: @user.id } }
    assert @group.valid?
    assert_redirected_to group_url(@group)
  end

  test "should destroy group" do
    assert_difference('Group.count', -1) do
      delete group_url(@group)
    end

    assert_redirected_to groups_url
  end
end
