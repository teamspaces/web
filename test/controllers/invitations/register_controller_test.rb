require 'test_helper'

describe Invitations::RegisterController do
  let(:invitation) { invitations(:jonas_at_furrow) }

  describe "#new" do
    it "renders :new" do
      get register_with_invitation_url(token: invitation.token)
      assert_response :success
    end
  end

  describe "#create" do
    context "valid" do
      let(:valid_params) do
        { register_with_invitation_form:
          { email: invitation.email,
            password: 'password', password_confirmation: 'password',
            invitation_token: invitation.token } }
      end

      it "creates user" do
        assert_difference ->{ User.count }, 1 do
          post register_with_invitation_forms_path(token: invitation.token), params: valid_params
        end
      end

      it "accepts team invitation" do
        post register_with_invitation_forms_path(token: invitation.token), params: valid_params

        assert invitation.team, @controller.current_user.teams.first
      end

      it "redirects to after sign in path" do
        post register_with_invitation_forms_path(token: invitation.token), params: valid_params

        assert_redirected_to @controller.after_sign_in_path_for(@controller.current_user)
      end
    end

    context "invalid" do
      let(:invalid_params) do
        { register_with_invitation_form:
          { email: invitation.email,
            password: 'wrong', password_confirmation: 'password',
            invitation_token: invitation.token } }
      end

      it "renders :new" do
        post register_with_invitation_forms_path(token: invitation.token), params: invalid_params

        assert_match "Password confirmation doesn&#39;t match Password", response.body
      end
    end
  end
end
