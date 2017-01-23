require "test_helper"

describe InvitationMailer do
  include Rails.application.routes.url_helpers

  let(:invitation) { invitations(:jonas_at_spaces) }
  let(:user) { users(:ulf) }

  describe "team invitation" do
    it "includes link with link to accept invitation path" do
      mail = InvitationMailer.join_team(invitation, user)

      html_body = mail.message.html_part.body.decoded
      text_body = mail.message.text_part.body.decoded

      [html_body, text_body].each do |body|
        assert body.include? accept_invitation_path(invitation.token)
      end
    end
  end
end
