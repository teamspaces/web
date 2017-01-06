require 'test_helper'

describe DeviceUsersCookie, :model do

  let(:subject) { DeviceUsersCookie.new({}) }
  let(:email_user) { users(:ulf) }
  let(:slack_user) { users(:slack_user_milad) }
  let(:filled) do
    device_users_cookie = subject
    device_users_cookie.add(email_user)
    device_users_cookie.add(slack_user)
    device_users_cookie
  end

  describe "#add" do
    it "adds user to stored" do
      assert_difference -> { subject.users.size }, 1 do
        subject.add(email_user)
      end
    end

    context "user already stored" do
      it "does nothing" do
        assert_difference -> { filled.users.size }, 0 do
          filled.add(email_user)
        end
      end
    end
  end

  describe "#remove" do
    it "removes user from stored" do
      assert_difference -> { filled.users.size }, -1 do
        filled.remove(email_user)
      end
    end
  end

  describe "#users" do
    it "returns stored users" do
      assert_equal [email_user, slack_user], filled.users
    end
  end

  describe "#teams" do
    it "returns stored users teams" do
      teams = (email_user.teams + slack_user.teams).uniq

      assert_equal teams, filled.teams
    end
  end
end
