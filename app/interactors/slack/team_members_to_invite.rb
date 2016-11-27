class Slack::TeamMembersToInvite
  include Interactor::Organizer

  organize Slack::FetchTeamMembers, Slack::FilterTeamMembersToInvite
end
