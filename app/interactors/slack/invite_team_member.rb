class Slack::InviteTeamMember
  include Interactor::Organizer

  organize Slack::FetchUserInfo, Slack::CreateInvitation, Slack::SendInvitation
end
