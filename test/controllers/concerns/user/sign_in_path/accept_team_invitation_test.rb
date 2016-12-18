require 'test_helper'

describe User::SignInPath::AcceptTeamInvitation, :controller do
  let(:invitation) { invitations(:katharina_at_power_rangers) }
  let(:email_invitee) { users(:without_team) }

  def set_invitation_cookie(token)
    get accept_invitation_path(token)
  end

  describe "#accept_team_invitation" do
    describe "invitation exists" do
      before(:each) { set_invitation_cookie(invitation.token) }

      describe "user is invitee" do
        it "accepts invitation" do
          assert_difference -> { invitation.team.members.count }, 1 do
            @controller.accept_team_invitation(email_invitee)
          end
        end

        it "shows notice" do
          @controller.accept_team_invitation(email_invitee)
          assert_equal I18n.t("successfully_accepted_invitation"), @controller.flash[:notice]
        end
      end

      describe "user is not invitee" do
        let(:not_invitee) { users(:lars) }
        before(:each) {  @controller.accept_team_invitation(not_invitee) }

        it "shows notice" do
          assert_equal I18n.t("invitation_does_not_match_user"), @controller.flash[:notice]
        end
      end
    end

    describe "invitation does not exist" do
      before(:each) do
        set_invitation_cookie("invalid")
        @controller.accept_team_invitation(email_invitee)
      end

      it "shows notice" do
        assert_equal I18n.t("invitation_does_not_exist"), @controller.flash[:notice]
      end
    end

    it "deletes invitation cookie" do
      set_invitation_cookie("token")
      @controller.expects(:destroy_invitation_cookie).once

      @controller.accept_team_invitation(email_invitee)
    end
  end
end
