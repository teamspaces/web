require "test_helper"

describe DestroyUserSessionsQuery, :model do
  set_fixture_class authie_sessions: Authie::Session

  let(:user) { users(:with_several_teams) }
  let(:spaces_team) { teams(:spaces) }
  let(:maja_spaces_session) { authie_sessions(:maja_at_spaces) }
  let(:sven_spaces_session) { authie_sessions(:sven_at_spaces) }
  let(:hassan_without_spaces_session) { authie_sessions(:hassan_at_without_space) }
  let(:maja_power_session) { authie_sessions(:maja_at_power) }
  let(:maja_inactive_spaces_session) { authie_sessions(:maja_inactive_at_spaces) }
  let(:maja_mobile_browser_session) { authie_sessions(:maja_mobile_browser) }

  subject { DestroyUserSessionsQuery }

  describe "#for_team!" do
    context "single user" do
      it "invalidates all team sessions for user" do
        subject.new(user: user).for_team!(spaces_team)

        refute maja_spaces_session.reload.active
        assert maja_power_session.reload.active
        assert sven_spaces_session.reload.active
        refute maja_inactive_spaces_session.reload.active
        assert hassan_without_spaces_session.reload.active
      end
    end

    context "all users" do
      it "invalidates all team sessions for users" do
        subject.new(user: :all).for_team!(spaces_team)

        refute maja_spaces_session.reload.active
        refute sven_spaces_session.reload.active
        assert hassan_without_spaces_session.reload.active
        assert maja_power_session.reload.active
      end
    end
  end

  describe "#for_browser!" do
    context "single user" do
      it "invalidates all browser sessions for user" do
        subject.new(user: user).for_browser!(maja_spaces_session.browser_id)

        refute maja_spaces_session.reload.active
        refute maja_power_session.reload.active
        assert hassan_without_spaces_session.reload.active
        refute maja_inactive_spaces_session.reload.active
        assert maja_mobile_browser_session.reload.active
      end
    end

    context "all users" do
      it "invalidates all browser sessions for all users" do
        subject.new(user: :all).for_browser!(maja_spaces_session.browser_id)

        refute maja_spaces_session.reload.active
        refute maja_power_session.reload.active
        refute hassan_without_spaces_session.reload.active
        assert maja_mobile_browser_session.reload.active
      end
    end
  end
end
