class Invitation::CreateAndSendSlackInvitation
  include Interactor::Organizer

  organize Invitation::SlackInvitation::Create, Invitation::Send
end
