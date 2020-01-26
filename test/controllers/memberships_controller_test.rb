require 'test_helper'

class MembershipsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @leader  =  users(:WrongPerson)
    @group   = groups(:Players)
    @recruit =  users(:RealPerson)
  end
  
  test "Membership behavior" do
    #a user can join a group, hereby becoming a member of that group
    assert_difference 'Membership.count' do
      @group.memberships.build(user_id: @recruit.id).save
    end
    assert @group.members.include?(@recruit)
    
    @membership = Membership.find_by(group: @group, user: @recruit)
    assert_not @membership.confirmed?
    
    #a user can't approve their own membership.
    sign_in @recruit
    patch membership_url(@membership), params: { membership: { group_id: @group.id,
                                                                user_id: @recruit.id,
                                                                 commit: "Accept" }}
    assert_not @membership.reload.confirmed?
    assert_redirected_to root_url
    
    #however, a group leader can approve memberships,
    sign_in @leader
    patch membership_url(@membership), params: { membership: { group_id: @group.id,
                                                                user_id: @recruit.id,
                                                                 commit: "Accept" }}
    assert @membership.reload.confirmed?
    
    #or remove them.
    delete membership_url(@membership), params: { membership: { group_id: @group.id,
                                                                 user_id: @recruit.id,
                                                                  commit: "Decline" }}
    assert_raise(ActiveRecord::RecordNotFound) { @membership.reload }
  end
end