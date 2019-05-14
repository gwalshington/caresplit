require 'test_helper'

class GroupInvitesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @group_invite = group_invites(:one)
  end

  test "should get index" do
    get group_invites_url
    assert_response :success
  end

  test "should get new" do
    get new_group_invite_url
    assert_response :success
  end

  test "should create group_invite" do
    assert_difference('GroupInvite.count') do
      post group_invites_url, params: { group_invite: { email: @group_invite.email, first_name: @group_invite.first_name, group_id: @group_invite.group_id, last_emailed: @group_invite.last_emailed, notes: @group_invite.notes, user_id: @group_invite.user_id } }
    end

    assert_redirected_to group_invite_url(GroupInvite.last)
  end

  test "should show group_invite" do
    get group_invite_url(@group_invite)
    assert_response :success
  end

  test "should get edit" do
    get edit_group_invite_url(@group_invite)
    assert_response :success
  end

  test "should update group_invite" do
    patch group_invite_url(@group_invite), params: { group_invite: { email: @group_invite.email, first_name: @group_invite.first_name, group_id: @group_invite.group_id, last_emailed: @group_invite.last_emailed, notes: @group_invite.notes, user_id: @group_invite.user_id } }
    assert_redirected_to group_invite_url(@group_invite)
  end

  test "should destroy group_invite" do
    assert_difference('GroupInvite.count', -1) do
      delete group_invite_url(@group_invite)
    end

    assert_redirected_to group_invites_url
  end
end
