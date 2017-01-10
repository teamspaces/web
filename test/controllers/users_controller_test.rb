require 'test_helper'

describe UsersController do
  let(:user) { users(:lars) }
  let(:team) { user.teams.first }

  before(:each) { sign_in user }

  describe "#show" do
    it "works" do
      get user_url(user, subdomain: team.subdomain)
      assert_response :success
    end
  end

  describe "#edit" do
    it "works" do
      get edit_user_url(user, subdomain: team.subdomain)

      assert_response :success
    end
  end

  describe "#update" do
    context "with valid attributes" do
      it "updates user attributes, responds" do

      end

      context "slack user" do
        it "does not allow to update email or password" do

        end
      end
    end

    context "with invalid attributes" do
      it "does not update attributes, responds" do

      end
    end
  end

  describe "#destroy" do
    it "deletes the user" do

    end

    it "redirects to the default subdomain root url" do

    end
  end

#  describe "#update" do
#    it "works" do
#      new_team_name = "Southside Security PLC"
#      patch team_url(subdomain: team.subdomain), params: { team: { name: new_team_name } }

#      team.reload
#      assert_equal new_team_name, team.name
#    end
#  end

#  describe "#destroy" do
#    it "works" do
#      assert_difference -> { Team.count }, -1 do
#        delete team_url(subdomain: team.subdomain)
#      end
#    end
#  end
end
