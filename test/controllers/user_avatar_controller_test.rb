require 'test_helper'

describe UserAvatarController do
  let(:user) { users(:with_one_space) }
  let(:team) { user.teams.first }

  before(:each) { sign_in user }

  describe "#destroy" do
    it "generates a new user avatar" do
      User::Avatar::AttachGeneratedAvatar.expects(:call)
                                         .with(user: user)
                                         .returns(true)

      delete user_avatar_url(subdomain: team.subdomain)
    end
  end
end
