require "test_helper"

describe TokenAuthentication::SignInUser, :model do
  let(:user) { users(:lars) }
  let(:team) { teams(:furrow) }
  let(:url) { "www.kilos.spaces.is/invitations" }
  let(:token_url) { TokenAuthentication::GenerateSignInUrl.call(user: user, url: url).url }
  subject { TokenAuthentication::SignInUser }


  it "creates url with token" do
    controller = ApplicationController.new
    controller.expects(:sign_in).with(user).returns(:ok)
    controller.expects(:redirect_to).returns(:ok)

    subject.call(url: token_url, controller: controller)
  end
end
