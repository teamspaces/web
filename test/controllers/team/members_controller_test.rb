require 'test_helper'

describe Team::MembersController do
  let(:user) { users(:ulf) }
  let(:team) { teams(:spaces) }
  let(:team_member) { team_members(:lars_at_spaces) }
  before(:each) { sign_in user}

  describe "#destroy" do
    it "works" do
      assert_difference -> { team.members.count }, -1 do
        delete team_member_url(team_member, subdomain: team.subdomain)
      end
    end

    it "signs out team-member from team-subdomain" do
      Authie::Session.expects(:sign_out_team_member_from_team_subdomain)
                     .with(team_member)

      delete team_member_url(team_member, subdomain: team.subdomain)
    end

    it "redirects to team path" do
      delete team_member_url(team_member, subdomain: team.subdomain)

      assert_redirected_to team_path
    end
  end
end
