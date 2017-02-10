require 'test_helper'

describe SpacesController do
  let(:user) { users(:ulf) }
  let(:team) { user.teams.first }
  let(:space) { team.spaces.first }
  before(:each) { sign_in user }

  describe "#index" do
    it "works" do
      get spaces_url(subdomain: team.subdomain)
      assert_response :success
    end
  end

  describe "#show" do
    it "works" do
      get space_url(space, subdomain: team.subdomain)
      assert_response :success
    end
  end

  describe "#new" do
    it "works" do
      get new_space_url(subdomain: team.subdomain)
      assert_response :success
    end
  end

  describe "#edit" do
    it "works" do
      get edit_space_url(space, subdomain: team.subdomain)
      assert_response :success
    end
  end

  describe "#create" do
    context "valid space attributes" do
      it "creates a space" do
        assert_difference -> { Space.count }, 1 do
          post spaces_url(subdomain: team.subdomain, params: { space: { name: "new_space", private_access_control: true } })
        end
      end
    end

    context "invalid space attributes" do
      it "does not create a space" do
        assert_difference -> { Space.count }, 0 do
          post spaces_url(subdomain: team.subdomain, params: { space: { name: nil } })
        end
      end
    end
  end

  describe "#update" do
    context "valid space attributes" do
      it "updates a space" do
        patch space_url(space, subdomain: team.subdomain, params: { space: { name: "new_name", private_access_control: true } })
        space.reload

        assert_equal "new_name", space.name
      end
    end

    context "invalid space attributes" do
      it "does not update a space" do
        patch space_url(space, subdomain: team.subdomain, params: { space: { name: nil }} )
        space.reload

        assert_equal "Spaces", space.name
      end
    end
  end

  describe "#destroy" do
    it "deletes an space" do
      assert_difference -> { Space.count }, -1 do
        delete space_url(space, subdomain: team.subdomain)
      end
    end
  end
end
