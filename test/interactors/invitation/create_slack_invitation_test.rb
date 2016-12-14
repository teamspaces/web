require "test_helper"

describe Invitation::CreateSlackInvitation, :model do
  let(:user) { users(:slack_user_emil) }
  let(:team) { teams(:spaces) }
  let(:valid_params) { { first_name: "Jessica", last_name: "Tol",
                         email: "jessica@nl.com", slack_user_id: "97sl3"} }

  it "creates slack invitation" do
    assert_difference -> { Invitation.count }, 1 do
      result = Invitation::CreateSlackInvitation.call({team: team, user: user}.merge(valid_params))

      assert result.success?
      assert_equal team, result.invitation.team
      assert_equal valid_params[:email], result.invitation.email
      assert_equal valid_params[:slack_user_id], result.invitation.slack_user_id
    end
  end
end
