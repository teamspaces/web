require 'test_helper'

describe Invitations::LoginController do
  let(:user) { users(:without_team) }
  let(:invitation) { invitations(:katharina_at_power_rangers) }

  describe "#new" do
    it "renders :new" do
      get login_with_invitation_url(token: invitation.token)
      assert_response :success
    end
  end

  describe "#create" do
    context "valid" do
      before(:each) do
        params = { login_with_invitation_form: { email: user.email, password: 'password', invitation_token: invitation.token} }
        post login_with_invitation_forms_path(token: invitation.token), params: params
      end

      it "accepts team invitation" do
        assert invitation.team, user.teams.first
      end

      it "signs in user" do
        assert user, @controller.current_user
      end

      it "redirects to after sign in path" do
        assert_redirected_to @controller.after_sign_in_path_for(user)
      end
    end

    context "invalid" do
      it "renders :new" do
        params = { login_with_invitation_form: { email: user.email, password: 'wrong', invitation_token: invitation.token} }
        post login_with_invitation_forms_path(token: invitation.token), params: params

        assert_match 'Invalid email or password', response.body
      end
    end
  end
end
