require "test_helper"

describe AvailableUsersQuery, :model do
  let(:email_user) { users(:lars) }
  let(:slack_user) { users(:slack_user_milad) }
  let(:with_one_space) { users(:with_one_space) }

  subject { AvailableUsersQuery.new(1) }

  def create_session(browser_id: 1, team_id: 1, user:, active: true)
    Authie::Session.create(browser_id: browser_id, team_id: team_id, user: user, active: active)
  end

  describe "#users" do
    it "only returns users of browser" do
      create_session(user: email_user,     browser_id: 1)
      create_session(user: slack_user,     browser_id: 1)
      create_session(user: with_one_space, browser_id: 2)

      assert subject.users.length == 2
    end

    it "only returns user with an active session" do
      create_session(user: email_user, active: true)
      create_session(user: slack_user, active: false)

      assert subject.users.length == 1
    end

    it "returns distinct users" do
      create_session(user: email_user, team_id: 1)
      create_session(user: email_user, team_id: 2)

      assert_equal subject.users.length == 1
    end
  end
end
