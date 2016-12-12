require "test_helper"

describe TeamDecorator, :model do

  describe "#connected_to_slack?" do
    context "team with team authentication" do
      let(:team_with_authentication) { teams(:furrow) }

      it "is true" do
        assert team_with_authentication.decorate.connected_to_slack?
      end
    end

    context "team without authentication" do
      let(:team_without_authentication) { teams(:power_rangers) }

      it "refutes" do
        refute team_without_authentication.decorate.connected_to_slack?
      end
    end
  end
end
