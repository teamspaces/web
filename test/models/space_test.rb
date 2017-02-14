require "test_helper"

describe Space do
  should have_many(:invitations)
  should have_many(:pages).dependent(:destroy)
  should have_many(:space_members).dependent(:destroy)
  should belong_to(:team)
  should validate_presence_of(:team)

  describe "#team_members" do

  end

  describe "#users" do
    it "returns space users" do
      assert true
    end
  end
end
