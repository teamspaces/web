require "test_helper"

describe GenerateLoginToken, :model do
  let(:user) { users(:lars) }

  describe "#call" do
    it "returns auth token" do
      token = GenerateLoginToken.call(user: user)
      assert token
    end
  end
end
