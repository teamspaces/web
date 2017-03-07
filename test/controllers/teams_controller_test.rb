require 'test_helper'

describe TeamsController do
  let(:user) { users(:lars) }
  let(:team) { teams(:spaces) }
  let(:auth_token) { "secret_token" }

  before(:each) { sign_in user }

  describe "#show" do
    context "user is team member" do
      it "works" do
        get team_url(subdomain: team.subdomain)
        assert_response :success
      end
    end

    context "user is not team member" do
      it "refutes access" do
        sign_in users(:without_team)
        get team_url(subdomain: team.subdomain)

        assert_redirected_to root_url(subdomain: ENV["DEFAULT_SUBDOMAIN"])
      end
    end
  end

  describe "#new" do
    before(:each) do
      AvailableUsersQuery.any_instance
                         .stub(:users)
                         .with([user])
    end

    it "works" do
      get new_team_url(user, subdomain: team.subdomain)
      assert_response :success
    end

    context "creating user is not authorized" do
      it "raises authorization error" do
        assert_raises Pundit::NotAuthorizedError do
          get new_team_url(users(:with_two_spaces), subdomain: team.subdomain)
        end
      end
    end
  end

  describe "#create" do
    let(:valid_params) {{team:{name: "bain ltd", subdomain: "baincompany"}}}
    let(:invalid_params){{team:{name:"bain ltd"}}}

    before(:each) do
      AvailableUsersQuery.any_instance
                         .stub(:users)
                         .with([user])
    end

    context "valid params" do
      it "works" do
        assert_difference -> { Team.count }, 1 do
          post team_url(user_id: user.id, subdomain: team.subdomain), params: valid_params

          assert_redirected_to @controller.sign_in_url_for(user: user, created_team_to_redirect_to: Team.last)
        end
      end
    end

    context "invalid params" do
      it "works" do
        assert_difference -> { Team.count }, 0 do
          post team_url(user_id: user.id, subdomain: team.subdomain), params: invalid_params

          assert_response :success
        end
      end
    end

    context "creating user is not authorized" do
      it "raises authorization error" do
        assert_raises Pundit::NotAuthorizedError do
          post team_url(user_id: users(:with_two_spaces).id, subdomain: team.subdomain), params: valid_params
        end
      end
    end
  end

  describe "#edit" do
    it "works" do
      get edit_team_url(subdomain: team.subdomain)

      assert_response :success
    end
  end

  describe "#update" do
    it "works" do
      new_team_name = "Southside Security PLC"
      patch team_url(subdomain: team.subdomain), params: { team: { name: new_team_name } }

      team.reload
      assert_equal new_team_name, team.name
    end
  end

  describe "#destroy" do
    it "works" do
      assert_difference -> { Team.count }, -1 do
        delete team_url(subdomain: team.subdomain)
      end
    end
  end
end
