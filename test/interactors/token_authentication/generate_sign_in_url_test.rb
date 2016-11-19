require "test_helper"

describe TokenAuthentication::GenerateSignInUrl, :model do
  let(:user) { users(:lars) }
  let(:team) { teams(:furrow) }
  let(:url) { "www.kilos.spaces.is/invitations" }

  it "creates url with token" do
    result = TokenAuthentication::GenerateSignInUrl.call(user: user, url: url)
  end
end
