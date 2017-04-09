require "test_helper"

describe AccountsPolicy, :model do
  let(:available_user) { users(:ulf) }
  let(:unavailable_user) { users(:lars) }
  let(:available_users) do
    available_users = AvailableUsersQuery.new(browser_id: "default")
    available_users.stubs(:users)
                   .returns([available_user])
    available_users
  end
  subject { AccountsPolicy }

  describe "#create_team?" do
    describe "user authorized to create team" do
      before(:each) do
        UserPolicy.any_instance
                  .stubs(:create_team?)
                  .returns(true)
      end

      context "available_user" do
        it "returns true" do
          assert subject.new(available_users, available_user).create_team?
        end
      end

      context "unavailable_user" do
        it "returns false" do
          refute subject.new(available_users, unavailable_user).create_team?
        end
      end
    end

    describe "user not authorized to create team" do
      before(:each) do
        UserPolicy.any_instance
                  .stubs(:create_team?)
                  .returns(false)
      end

      context "available_user" do
        it "returns false" do
          assert subject.new(available_users, available_user).create_team?
        end
      end

      context "unavailable_user" do
        it "returns false" do
          refute subject.new(available_users, unavailable_user).create_team?
        end
      end
    end
  end
end
