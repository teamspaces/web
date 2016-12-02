require "test_helper"

describe User::AcceptInvitationPolicy, :model do

  describe "#matching?" do

    describe "slack invitation" do
      describe "slack user" do
        context "matching" do
          it "allows" do

          end
        end

        context "non matching" do
          it "refutes" do

          end
        end
      end

      describe "email user" do
        it "refutes" do

        end
      end
    end

    describe "email invitation" do
      describe "email user" do
        context "matching" do
          it "allows" do

          end
        end

        context "non matching" do
          it "refutes" do

          end
        end
      end

      describe "slack user" do
        context "matching email" do
          it "allows" do

          end
        end
      end
    end
  end
end
