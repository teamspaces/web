require 'test_helper'

describe TeamsController do
  let(:user) { users(:lars) }
  let(:available_user) { users(:ulf) }
  let(:team) { teams(:spaces) }
  let(:auth_token) { "secret_token" }
  let(:external_user) { users(:with_two_spaces) }

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
    context "user for team is authorized" do
      it "works" do
        stub_available_users_policy_for(user: available_user,
                                        method: :create_team?,
                                        return_value: true)

        get new_team_url(available_user, subdomain: team.subdomain)
        assert_response :success
      end
    end

    context "user for team is not authorized" do
      it "raises authorization error" do
        stub_available_users_policy_for(user: external_user,
                                        method: :create_team?,
                                        return_value: false)

        assert_raises Pundit::NotAuthorizedError do
          get new_team_url(external_user, subdomain: team.subdomain)
        end
      end
    end
  end

  describe "#create" do
    let(:valid_params) { { team: { name: "bain ltd", subdomain: "baincompany" } } }
    let(:invalid_params) { { team: { name:"bain ltd" } } }

    describe "user for team is authorized" do
      before(:each) do
        stub_available_users_policy_for(user: available_user,
                                        method: :create_team?,
                                        return_value: true)
      end

      context "valid params" do
        it "works" do
          assert_difference -> { Team.count }, 1 do
            post team_url(user_id: available_user.id, subdomain: team.subdomain), params: valid_params

            assert_redirected_to @controller.sign_in_url_for(user: available_user, created_team_to_redirect_to: Team.last)
          end
        end
      end

      context "invalid params" do
        it "works" do
          assert_difference -> { Team.count }, 0 do
            post team_url(user_id: available_user.id, subdomain: team.subdomain), params: invalid_params

            assert_response :success
          end
        end
      end
    end

    describe "user for team is not authorized" do
      it "raises authorization error" do
        stub_available_users_policy_for(user: external_user,
                                        method: :create_team?,
                                        return_value: false)

        assert_raises Pundit::NotAuthorizedError do
          post team_url(user_id: external_user.id, subdomain: team.subdomain), params: valid_params
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

    context "update subdomain" do
      it "does not update subdomain" do
        new_subdomain = "newsubdomain"
        patch team_url(subdomain: team.subdomain), params: { team: { subdomain: new_subdomain } }

        team.reload
        assert_not_equal new_subdomain, team.subdomain
      end
    end
  end

  describe "#destroy" do
    it "works" do
      assert_difference -> { Team.count }, -1 do
        delete team_url(subdomain: team.subdomain)
      end
    end
  end

  private

    def stub_available_users_policy_for(user:, method:, return_value:)
      AvailableUsersPolicy.expects(:new)
                          .with(anything, user)
                          .returns(policy_mock = mock)

      policy_mock.expects(method).returns(return_value)
    end
end
