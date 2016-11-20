require "test_helper"

describe GenerateTokenLoginUrl, :model do
  let(:user) { users(:lars) }
  let(:url) { "www.kilos.spaces.is/invitations" }

  describe "#call" do
    it "returns login url" do
      result = GenerateTokenLoginUrl.call(url: url, user: user)

      assert_match url, result.url
      assert url.length < result.url.length
    end
  end
end
