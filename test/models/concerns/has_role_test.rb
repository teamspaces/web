require 'test_helper'

class HasRoleTest < ActiveSupport::TestCase
  let(:primary_owner) { team_members(:ulf_at_spaces) }
  let(:owner)         { team_members(:sven_at_spaces) }
  let(:member)        { team_members(:lars_at_spaces) }

  describe "#primary_owner?" do
    it "returns true for primary owners" do
      assert_equal true, primary_owner.primary_owner?
    end

    it "returns false for everything else" do
      assert_equal false, primary_owner.owner?
      assert_equal false, primary_owner.member?
    end
  end

  describe "#owner?" do
    it "returns true for primary owners" do
      assert_equal true, owner.owner?
    end

    it "returns false for everything else" do
      assert_equal false, owner.primary_owner?
      assert_equal false, owner.member?
    end
  end

  describe "#member?" do
    it "returns true for members" do
      assert_equal true, member.member?
    end

    it "returns false for everything else" do
      assert_equal false, member.primary_owner?
      assert_equal false, member.owner?
    end
  end
end
