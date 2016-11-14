require 'test_helper'

describe Team do
  let(:team) { teams(:furrow) }

  describe "associations" do
    it "should have many team_members" do
      assert team.team_members.count >= 0
    end
  end
end
