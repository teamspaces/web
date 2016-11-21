require "test_helper"

describe AuthorizeLoginWithToken, :model do
  let(:user) { users(:lars) }
  let(:auth_token) { GenerateLoginToken.call(user: user) }
  let(:sign_in_url) { landing_url(auth_token: auth_token) }

  describe "#call" do
    context "sign_in_url" do
      it "asserts login with token" do
        result = AuthorizeLoginWithToken.call(url: sign_in_url)

        assert result.success?
        assert_equal user, result.user
        assert_equal standard_url, result.url
      end
    end

    context "standard_url" do
      it "refutes login" do
        result = AuthorizeLoginWithToken.call(url: standard_url)

        refute result.success?
      end
    end
  end
end
