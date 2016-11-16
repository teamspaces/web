class Invitation::CreateAndSendJoinTeamMail
  include Interactor::Organizer

  organize Invitation::CreateInvitation, Invitation::SendJoinTeamInvitation
end
