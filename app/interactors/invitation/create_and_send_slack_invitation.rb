class Invitation::CreateAndSendSlackInvitation
  include Interactor::Organizer

  organize Invitation::SlackInvitation::Create, Invitation::SendInvitation
end
