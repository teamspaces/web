require "test_helper"

describe SlackTeamAuthenticationPolicy, :model do

  context "team with slack team members" do
    describe "team authorization for same team like team-member login" do
      it "allows team authorization" do

      end
    end

    describe "team authorization is not for the same team like team members login" do
      it "refutes team authorization" do

      end
    end
  end

  context "team with team slack authorization to slack" do
    describe "existing slack authorization is for same team" do
      it "allows team authorization" do

      end
    end

    describe "existing slack authorization is for another team" do
      it "refutes team authorization" do

      end
    end
  end

  context "team has only email user and not slack team authorization" do
    describe "primary owner adds slack team authorization" do
      it "allows team authorization for any slack team" do

      end
    end

    describe "user is not primary owner" do
      it "refutes team authorization" do

      end
    end
  end
end
