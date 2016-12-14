require "test_helper"

describe InvitationMailer do
  let(:invitation) { invitations(:jonas_at_spaces) }

  describe "join team invitation" do
    it "redirects to landing page with invitation token" do
      mail = InvitationMailer.join_team(invitation)

      html_body = mail.message.html_part.body.decoded
      text_body = mail.message.text_part.body.decoded

      landing_url_part = "/landing?invitation_token=#{invitation.token}"
      [html_body, text_body].each { |body| assert body.include? landing_url_part }
    end
  end
end
