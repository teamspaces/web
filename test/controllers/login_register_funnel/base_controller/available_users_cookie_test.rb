require 'test_helper'

describe LoginRegisterFunnel::BaseController::AvailableUsersCookie, :controller do
  let(:email_user) { users(:ulf) }
  let(:slack_user) { users(:slack_user_milad) }
  let(:controller) { get root_url(subdomain: ENV["DEFAULT_SUBDOMAIN"]); @controller }
  let(:available_users_cookie) { LoginRegisterFunnel::BaseController::AvailableUsersCookie.new(controller.send(:cookies)) }
  let(:cookie_with_email_and_slack_user) do
    device_users_cookie = available_users_cookie
    device_users_cookie.add(email_user)
    device_users_cookie.add(slack_user)
    device_users_cookie
  end

  describe "#add" do
    it "adds user to available users" do
      assert_difference -> { available_users_cookie.users.size }, 1 do
        available_users_cookie.add(email_user)
      end
    end

    context "user already in available users" do
      it "does nothing" do
        assert_difference -> { cookie_with_email_and_slack_user.users.size }, 0 do
          cookie_with_email_and_slack_user.add(email_user)
        end
      end
    end
  end

  describe "#remove" do
    it "removes user from available users" do
      assert_difference -> { cookie_with_email_and_slack_user.users.size }, -1 do
        cookie_with_email_and_slack_user.remove(email_user)
      end
    end
  end

  describe "#users" do
    it "returns available users" do
      assert_equal [email_user, slack_user], cookie_with_email_and_slack_user.users
    end
  end

  describe "#teams" do
    it "returns available users teams" do
      device_users_teams = (email_user.teams + slack_user.teams).uniq

      assert_equal device_users_teams, cookie_with_email_and_slack_user.teams
    end
  end
end
