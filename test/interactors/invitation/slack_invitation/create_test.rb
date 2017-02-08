require "test_helper"

describe Invitation::SlackInvitation::Create, :model do
  let(:user) { users(:slack_user_emil) }
  let(:team) { teams(:spaces) }
  let(:valid_invitation_params) { { first_name: "Jessica", last_name: "Tol",
                                    email: "jessica@nl.com", invited_slack_user_uid: "97sl3"} }

  it "creates slack invitation" do
    assert_difference -> { Invitation.count }, 1 do
      result = Invitation::SlackInvitation::Create.call(team: team,
                                                        invited_by_user: user,
                                                        invitation_attributes: valid_invitation_params)

      assert result.success?
      assert_equal team, result.invitation.team
      assert_equal valid_invitation_params[:email], result.invitation.email
      assert_equal valid_invitation_params[:invited_slack_user_uid], result.invitation.invited_slack_user_uid
    end
  end
end
