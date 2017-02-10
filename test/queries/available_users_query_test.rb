require "test_helper"

describe AvailableUsersQuery, :model do
  let(:email_user) { users(:lars) }
  let(:slack_user) { users(:slack_user_milad) }
  let(:with_one_space) { users(:with_one_space) }
  let(:with_several_teams) { users(:with_several_teams) }
  before(:each) {  Authie::Session.delete_all }

  subject { AvailableUsersQuery.new(browser_id: 1) }

  def create_session(browser_id: 1, team_id: 1, user:, active: true)
    Authie::Session.create(browser_id: browser_id, team_id: team_id, user: user, active: active)
  end

  describe "#users" do

    it "only returns users of browser" do
      create_session(user: email_user,     browser_id: 1)
      create_session(user: slack_user,     browser_id: 1)
      create_session(user: with_one_space, browser_id: 2)

      assert_equal 2, subject.users.length
      assert_includes subject.users, email_user
      assert_includes subject.users, slack_user
    end

    it "only returns user with an active session" do
      create_session(user: email_user, active: true)
      create_session(user: slack_user, active: false)

      assert_equal [email_user], subject.users
    end

    it "returns distinct users" do
      create_session(user: email_user, team_id: 1)
      create_session(user: email_user, team_id: 2)

      assert_equal [email_user], subject.users
    end
  end

  describe "#teams" do
    it "returns all teams of active users" do
      create_session(user: email_user)
      create_session(user: with_one_space)
      create_session(user: team_members(:maja_at_power).user, active: false)

      [email_user.teams, with_one_space.teams].flatten.each do |team|
        assert_includes subject.teams, team
      end

      assert_not_includes subject.teams, teams(:power_rangers)
    end
  end

  describe "#user_signed_in_on_another_subdomain" do
    let(:first_users_team) { teams(:spaces) }
    let(:second_users_team) { teams(:power_rangers) }

    it "returns the team-user who is already signed in on another team subdomain" do
      create_session(user: with_several_teams, team_id: first_users_team.id)
      create_session(user: with_one_space)

      assert_equal with_several_teams, subject.user_signed_in_on_another_subdomain(second_users_team)
    end
  end
end
