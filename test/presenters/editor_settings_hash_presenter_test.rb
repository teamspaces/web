require "test_helper"

describe EditorSettingsHashPresenter, :model do
  subject do
    EditorSettingsHashPresenter.new(controller: controller_mock,
                                    user: user,
                                    page: page)
  end

  let(:user) { users(:ulf) }
  let(:page) { pages(:spaces) }
  let(:controller_mock) do
    controller_mock = mock
    controller_mock.stubs(:collab_url).returns("fake_collab_url")
    controller_mock.stubs(:page_content_url).returns("fake_page_content_url")
    controller_mock.stubs(:edit_page_url).returns("fake_edit_page_url")

    view_context_mock = mock
    view_context_mock.stubs(:form_authenticity_token).returns("fake_token")

    controller_mock.stubs(:view_context).returns(view_context_mock)

    controller_mock
  end

  describe "#to_hash" do
    it "formats correctly" do
      hash = subject.to_hash

      assert_equal "collab_pages", hash[:collection]

      assert_instance_of String, hash[:document_id]
      assert_instance_of Fixnum, hash[:expires_at]

      assert_match /#{ENV["COLLAB_SERVICE_URL"]}.*.token=.*/, hash[:collab_url]

      assert_equal "fake_page_content_url", hash[:page_content_url]
      assert_equal "fake_edit_page_url", hash[:edit_page_url]
      assert_equal "fake_token", hash[:csrf_token]
    end
  end
end
