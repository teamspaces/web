class Invitation::CreateAndSendSlackInvitation
  include Interactor::Organizer

  organize Invitation::Slack::Create,
           Invitation::Send
end
