require "test_helper"

describe Space::AccessControl, :model do
  let(:space) { spaces(:power_rangers) }

  describe "#private?" do
    context "private" do
      it "returns true" do
        space.access_control = :private
        assert space.access_control.private?
      end
    end

    context "team" do
      it "returns false" do
        space.access_control = :team
        refute space.access_control.private?
      end
    end
  end

  describe "#team?" do
    context "team" do
      it "returns true" do
        space.access_control = :team
        assert space.access_control.team?
      end
    end

    context "private" do
      it "returns false" do
        space.access_control = :private
        refute space.access_control.team?
      end
    end
  end
end
