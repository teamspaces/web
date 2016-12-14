require "test_helper"

describe TeamDecorator, :model do

  describe "#connected_to_slack?" do
    context "team with slack team authentication" do
      let(:team_with_slack_authentication) { teams(:spaces).decorate }

      it "is true" do
        assert team_with_slack_authentication.connected_to_slack?
      end
    end

    context "team without slack team authentication" do
      let(:team_without_slack_team_authentication) { teams(:power_rangers).decorate }

      it "refutes" do
        refute team_without_slack_team_authentication.connected_to_slack?
      end
    end
  end
end
