require "test_helper"

describe DestroyUserSessionsQuery, :model do
  set_fixture_class authie_sessions: Authie::Session

  let(:user) { users(:with_several_teams) }
  let(:spaces_team) { teams(:spaces) }
  let(:maja_spaces_session) { authie_sessions(:maja_at_spaces) }
  let(:hassan_without_spaces_session) { authie_sessions(:hassan_at_without_space) }
  let(:maja_power_session) { authie_sessions(:maja_at_power) }
  let(:maja_inactive_spaces_session) { authie_sessions(:maja_inactive_at_spaces) }
  let(:maja_mobile_browser_session) { authie_sessions(:maja_mobile_browser) }

  subject { DestroyUserSessionsQuery }

  describe "#for_team!" do
    context "single user" do
      it "invalidates all team sessions for user" do
        sessions = subject.new(user: user).send(:active_user_sessions_for_team, spaces_team)

        assert_includes sessions, maja_spaces_session
        assert_not_includes sessions, hassan_without_spaces_session
        assert_not_includes sessions, maja_power_session
        assert_not_includes sessions, maja_inactive_spaces_session
      end
    end

    context "all users" do
      it "invalidates all team sessions for users" do
        sessions = subject.new(user: :all).send(:active_user_sessions_for_team, spaces_team)

        assert_includes sessions, maja_spaces_session
        assert_not_includes sessions, hassan_without_spaces_session
        assert_not_includes sessions, maja_power_session
        assert_not_includes sessions, maja_inactive_spaces_session
      end
    end
  end

  describe "#for_browser!" do
    context "single user" do
      it "invalidates all browser sessions for user" do
        sessions = subject.new(user: user).send(:active_user_sessions_for_browser, maja_spaces_session.browser_id)

        assert_includes sessions, maja_spaces_session
        assert_includes sessions, maja_power_session
        assert_not_includes sessions, hassan_without_spaces_session
        assert_not_includes sessions, maja_inactive_spaces_session
        assert_not_includes sessions, maja_mobile_browser_session
      end
    end

    context "all users" do
      it "invalidates all browser sessions for all users" do
        sessions = subject.new(user: :all).send(:active_user_sessions_for_browser, maja_spaces_session.browser_id)

        assert_includes sessions, maja_spaces_session
        assert_includes sessions, maja_power_session
        assert_includes sessions, hassan_without_spaces_session
        assert_not_includes sessions, maja_inactive_spaces_session
        assert_not_includes sessions, maja_mobile_browser_session
      end
    end
  end
end
