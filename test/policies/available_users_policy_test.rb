require "test_helper"

describe AvailableUsersPolicy, :model do
  let(:available_user) { users(:ulf) }
  let(:external_user) { users(:lars) }
  let(:available_users) do
    available_users = AvailableUsersQuery.new(browser_id: "default")
    available_users.stubs(:users)
                   .returns([available_user])
    available_users
  end
  subject { AvailableUsersPolicy }

  describe "#create_team?" do
    context "available_user" do
      it "returns true" do
        assert subject.new(available_users, available_user).create_team?
      end
    end

    context "external_user" do
      it "returns false" do
        refute subject.new(available_users, external_user).create_team?
      end
    end
  end
end
