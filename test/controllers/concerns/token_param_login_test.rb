require 'test_helper'

describe TokenParamLogin, :model do
  let(:url) { "www.spaces.is?"}
  let(:user) { users(:lars) }
  let(:sign_in_url) { GenerateTokenLoginUrl.call(url: url, user: user).url }
  let(:controller_with_sign_in_request) do
    controller = ApplicationController.new
    controller.stubs(:request).returns(request_mock = mock)
    request_mock.stubs(:original_url).returns(sign_in_url)
    controller
  end

  describe "#token_authentication_requested?" do
    context "sign in url" do
      it "signs in user and redirects to url" do
        controller = controller_with_sign_in_request

        controller.expects(:sign_in).with(user)
        controller.expects(:redirect_to).with(url)

        controller.token_authentication_requested?
      end
    end
  end
end
