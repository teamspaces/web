require 'test_helper'

describe AvailableUsersCookie, :model do

  let(:subject) { AvailableUsersCookie.new({}) }
  let(:email_user) { users(:ulf) }
  let(:slack_user) { users(:slack_user_milad) }
  let(:cookie_with_email_and_slack_user) do
    device_users_cookie = subject
    device_users_cookie.add(email_user)
    device_users_cookie.add(slack_user)
    device_users_cookie
  end

  describe "#add" do
    it "adds user device users" do
      assert_difference -> { subject.users.size }, 1 do
        subject.add(email_user)
      end
    end

    context "user already in device users" do
      it "does nothing" do
        assert_difference -> { cookie_with_email_and_slack_user.users.size }, 0 do
          cookie_with_email_and_slack_user.add(email_user)
        end
      end
    end
  end

  describe "#remove" do
    it "removes user from device users" do
      assert_difference -> { cookie_with_email_and_slack_user.users.size }, -1 do
        cookie_with_email_and_slack_user.remove(email_user)
      end
    end
  end

  describe "#users" do
    it "returns device users" do
      assert_equal [email_user, slack_user], cookie_with_email_and_slack_user.users
    end
  end

  describe "#teams" do
    it "returns device users teams" do
      device_users_teams = (email_user.teams + slack_user.teams).uniq

      assert_equal device_users_teams, cookie_with_email_and_slack_user.teams
    end
  end
end
