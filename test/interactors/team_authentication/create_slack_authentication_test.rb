require "test_helper"

describe TeamAuthentication::CreateSlackAuthentication, :model do
  let(:token) { "secret_token" }
  let(:scopes) { ["users:read", "chat:write:bot"] }
  let(:slack_provider) { "slack" }
  let(:team_uid) { "T39w6"}
  subject { TeamAuthentication::CreateSlackAuthentication }

  describe "#call" do
    context "team without slack authentication" do
      let(:team_without_authentication) { teams(:power_rangers) }

      it "creates a slack team authentication" do
        assert_difference -> { TeamAuthentication.count }, 1 do
          result = subject.call(team: team_without_authentication,
                                token: token,
                                team_uid: team_uid,
                                scopes: scopes)

          assert result.success?
          assert_equal slack_provider, result.team_authentication.provider
          assert_equal token, result.team_authentication.token
          assert_equal team_without_authentication, result.team_authentication.team
          assert_equal team_uid, result.team_authentication.team_uid
        end
      end
    end

    context "team with slack authentication" do
      let(:team_with_authentication) { teams(:spaces) }

      it "updates slack team authentication" do
        assert_difference -> { TeamAuthentication.count }, 0 do
          result = subject.call(team: team_with_authentication,
                                token: token,
                                team_uid: team_uid,
                                scopes: scopes)

          assert result.success?
          assert_equal slack_provider, result.team_authentication.provider
          assert_equal token, result.team_authentication.token
          assert_equal team_with_authentication, result.team_authentication.team
          assert_equal team_uid, result.team_authentication.team_uid
        end
      end
    end
  end
end
