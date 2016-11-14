require 'test_helper'

describe User do
  let(:user) { users(:ulf) }

  describe "associations" do
    it "is member of many teams" do
      assert user.team_members.count >= 0
    end
  end

  describe "#name" do
    it "responds" do
      assert_equal "#{user.first_name} #{user.last_name}", user.name
    end
  end

  describe "#name=" do
    it "updates attributes" do
      user.name = "Lassie Chulo King"
      assert_equal "Lassie", user.first_name
      assert_equal "Chulo King", user.last_name
    end
  end
end
