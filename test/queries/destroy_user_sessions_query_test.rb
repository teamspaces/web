require "test_helper"

describe DestroyUserSessionsQuery, :model do
  let(:user) { users(:with_several_teams) }
  let(:spaces_team) { teams(:spaces) }
  let(:spaces_session) { authie_sessions(:maja_at_spaces) }
  let(:power_session) { authie_sessions(:maja_at_power) }
  let(:inactive_session) { authie_sessions(:maja_inactive) }
  let(:mobile_browser_session) { authie_sessions(:maja_mobile_browser) }

  subject { DestroyUserSessionsQuery }

  describe "#for_team!" do
    it "invalidates all team sessions for user" do
      spaces_session.expects(:invalidate!)
      power_session.expects(:invalidate!).never

      subject.new(user).for_team!(spaces_team)
    end
  end

  describe "#for_browser!" do
    it "invalidates all browser sessions for user" do
      power_session.expects(:invalidate!)
      spaces_session.expects(:invalidate!)
      mobile_browser_session.expects(:invalidate!).never

      subject.new(user).for_team!(spaces_team)
    end
  end
end
