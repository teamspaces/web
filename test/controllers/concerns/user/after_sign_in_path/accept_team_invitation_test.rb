require 'test_helper'

describe User::AfterSignInPath::AcceptTeamInvitation, :controller do
  let(:invitation) { invitations(:katharina_at_power_rangers) }
  let(:email_invitee) { users(:without_team) }
  let(:not_invitee) { users(:lars) }

  def set_invitation_cookie(token)
    get choose_login_method_path, params: { invitation_token: token }
  end

  describe "#accept_team_invitation" do
    describe "invitation exists" do
      before(:each) { set_invitation_cookie(invitation.token) }

      describe "user is invitee" do
        before(:each) { @controller.sign_in(email_invitee) }

        it "accepts invitation" do
          assert_difference -> { invitation.team.members.count }, 1 do
            @controller.accept_team_invitation
          end
        end

        it "shows notice" do
          @controller.accept_team_invitation
          assert_equal I18n.t("successfully_accepted_invitation"), @controller.flash[:notice]
        end
      end

      describe "user is not invitee" do
        before(:each) do
          @controller.sign_in(not_invitee)
          @controller.accept_team_invitation
        end

        it "shows notice" do
          assert_equal I18n.t("invitation_does_not_match_user"), @controller.flash[:notice]
        end
      end
    end

    describe "invitation does not exist" do
      before(:each) do
        set_invitation_cookie("invalid")
        @controller.accept_team_invitation
      end

      it "shows notice" do
        assert_equal I18n.t("invitation_does_not_exist"), @controller.flash[:notice]
      end
    end

    it "deletes invitation cookie" do
      set_invitation_cookie("token")
      @controller.expects(:destroy_invitation_cookie).once

      @controller.accept_team_invitation
    end
  end
end
