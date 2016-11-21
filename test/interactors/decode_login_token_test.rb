require "test_helper"

describe DecodeLoginToken, :model do
  let(:user) { users(:lars) }
  let(:token) { GenerateLoginToken.call(user: user) }
  subject { DecodeLoginToken }

  describe "#call" do
    context "valid" do
      it "returns user" do
        result = subject.call(token: token)

        assert result.success?
        assert_equal user, result.user
      end
    end

    context "expired" do
      it "fails" do
        auth_token = token

        travel 2.minutes do
          refute subject.call(token: auth_token).success?
        end
      end
    end

    context "invalid" do
      it "fails" do
        refute subject.call(token: nil).success?
        refute subject.call(token: "invalid").success?
      end
    end
  end
end
