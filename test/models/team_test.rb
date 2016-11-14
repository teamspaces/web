require 'test_helper'

describe Team do
  let(:team) { teams(:furrow) }

  describe "associations" do
    it "should have many team_members" do
      assert team.members.count.positive?
    end
  end
end
