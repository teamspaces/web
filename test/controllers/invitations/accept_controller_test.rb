require 'test_helper'

describe Invitations::AcceptController do

  describe "#show" do
    it "renders the :show view" do
       get accept_invitation_path
       assert_response :success
    end
  end
end
