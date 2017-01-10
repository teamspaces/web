require 'test_helper'

describe UsersController do
  let(:user) { users(:with_one_space) }
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
      it "updates user attributes" do
        user_params = { first_name: "Anna", last_name: "Betz", email: "new@email.com", password: "secret", password_confirmation: "secret"}
        patch user_url(user, subdomain: team.subdomain), params: { user: user_params }
        user.reload

        assert_equal "Anna", user.first_name
        assert_equal "Betz", user.last_name
        assert_equal "new@email.com", user.email
        assert_equal "secret", user.password
      end

      describe "slack user" do
        let(:slack_user) { users(:slack_user_milad) }

        it "does not allow to update email or password" do
          sign_in slack_user
          user_params = { first_name: "Anna", email: "new@email.com", password: "new_secret", password_confirmation: "new_secret"}
          patch user_url(slack_user, subdomain: slack_user.teams.first.subdomain), params: { user: user_params }
          slack_user.reload

          assert_equal "Anna", slack_user.first_name
          assert_not_equal "new_secret", slack_user.password
          assert_not_equal "new@email.com", slack_user.email
        end
      end
    end

    context "with invalid attributes" do
      it "does not update attributes" do
        invalid_user_params = { first_name: "Anna", email: "invalid"}
        patch user_url(user, subdomain: team.subdomain), params: { user: invalid_user_params }
        user.reload

        assert_not_equal "Anna", user.first_name
      end
    end
  end

  describe "#destroy" do
    it "deletes the user" do
      assert_difference -> { User.count }, -1 do
        delete user_url(user, subdomain: team.subdomain)
      end
    end

    it "redirects to the default subdomain root url" do
      delete user_url(user, subdomain: team.subdomain)

      assert_redirected_to root_url(subdomain: ENV["DEFAULT_SUBDOMAIN"])
    end
  end
end
