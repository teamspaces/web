require "test_helper"

describe TokenAuthentication::SignInUser, :model do
  let(:user) { users(:lars) }
  let(:team) { teams(:furrow) }
  let(:url) { "www.kilos.spaces.is/invitations?" }
  let(:url_with_token_param) { TokenAuthentication::GenerateSignInUrl.call(user: user, url: url).url }
  subject { TokenAuthentication::SignInUser }

  it "signs in user, redirects to url without token_param" do
    controller = ApplicationController.new
    controller.expects(:sign_in).with(user)
    controller.expects(:redirect_to).with(url)

    subject.call(url: url_with_token_param, controller: controller)
  end
end
