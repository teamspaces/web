require "test_helper"

describe User::SessionsController do
  let(:user) { users(:with_one_space) }
  let(:team) { user.teams.first }
  let(:subject) { User::SessionsController }

  describe "#destroy" do
    context "current_user present" do
      it "signs out all users from browsers and redirects to landing page" do
        sign_in user

        subject.any_instance.expects(:sign_out_all_users_from_browser)

        delete destroy_user_session_url(subdomain: team.subdomain)

        assert_redirected_to root_url(subdomain: ENV["DEFAULT_SUBDOMAIN"])
      end
    end

    context "current_user not present" do
      it "signs out all users from browsers and redirects to landing page" do
        subject.any_instance.expects(:sign_out_all_users_from_browser)

        delete destroy_user_session_path

        assert_redirected_to root_url(subdomain: ENV["DEFAULT_SUBDOMAIN"])
      end
    end
  end
end
