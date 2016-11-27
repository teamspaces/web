require 'test_helper'

describe TokenParamLogin, :controller do
  let(:user) { users(:lars) }

  describe "#token_authentication_requested?" do
    context "valid" do
      it "signs in user" do
        get landing_url(auth_token: GenerateLoginToken.call(user: user))

        assert_equal user, controller.current_user
      end
    end
  end
end
