require 'test_helper'

describe Team::MembersController do
  let(:team_member) { team_members(:erik_at_with_one_space) }
  let(:user) { team_member.user }
  let(:team) { team_member.team }
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
