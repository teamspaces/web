require "test_helper"

describe DestroyUserSessionsQuery, :model do
  set_fixture_class authie_sessions: Authie::Session

  let(:user) { users(:with_several_teams) }
  let(:spaces_team) { teams(:spaces) }
  let(:spaces_session) { authie_sessions(:maja_at_spaces) }
  let(:power_session) { authie_sessions(:maja_at_power) }
  let(:inactive_session) { authie_sessions(:maja_inactive) }
  let(:mobile_browser_session) { authie_sessions(:maja_mobile_browser) }

  subject { DestroyUserSessionsQuery }

  describe "#for_team!" do
    it "invalidates all team sessions for user" do
      sessions = subject.new(user).send(:active_user_sessions_for_team, spaces_team)

      assert_includes sessions, spaces_session
      assert_not_includes sessions, power_session
      assert_not_includes sessions, inactive_session
    end
  end

  describe "#for_browser!" do
    it "invalidates all browser sessions for user" do
      sessions = subject.new(user).send(:active_user_sessions_for_browser, spaces_session.browser_id)

      assert_includes sessions, spaces_session
      assert_includes sessions, power_session
      assert_not_includes sessions, inactive_session
      assert_not_includes sessions, mobile_browser_session
    end
  end
end
