require "test_helper"

describe TeamAuthentication::CreateSlackAuthentication, :model do
  let(:token) { "secret_token" }
  let(:scopes) { ["users:read", "chat:write:bot"] }
  let(:provider) { "slack" }
  subject { TeamAuthentication::CreateSlackAuthentication }

  describe "#call" do
    context "team without slack authentication" do
      let(:team_without_authentication) { teams(:power_rangers) }

      it "creates a slack team authentication" do
        assert_difference -> { TeamAuthentication.count }, 1 do
          result = subject.call(team: team_without_authentication,
                                token: token,
                                scopes: scopes)

          assert result.success?
          assert_equal provider, result.team_authentication.provider
          assert_equal token, result.team_authentication.token
          assert_equal team_without_authentication, result.team_authentication.team
        end
      end
    end

    context "team with slack authentication" do
      let(:team_with_authentication) { teams(:furrow) }

      it "updates slack team authentication" do
        assert_difference -> { TeamAuthentication.count }, 0 do
          result = subject.call(team: team_with_authentication,
                                token: token,
                                scopes: scopes)

          assert result.success?
          assert_equal provider, result.team_authentication.provider
          assert_equal token, result.team_authentication.token
          assert_equal team_with_authentication, result.team_authentication.team
        end
      end
    end
  end
end
