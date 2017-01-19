require 'test_helper'

describe User::AvatarsController do
  let(:user) { users(:with_one_space) }
  let(:team) { user.teams.first }

  before(:each) do
    User::Avatar::AttachGeneratedAvatar.stubs(:call).returns(true)

    sign_in user
  end

  describe "#destroy" do
    it "generates a new user avatar" do
      User::Avatar::AttachGeneratedAvatar.expects(:call)
                                         .with(user: user)
                                         .returns(true)

      delete user_avatar_url(subdomain: team.subdomain)
    end

    it "redirects to user path" do
      delete user_avatar_url(subdomain: team.subdomain)

      assert_redirected_to user_path
    end
  end
end
