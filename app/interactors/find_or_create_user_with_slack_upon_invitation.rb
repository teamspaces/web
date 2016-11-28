class FindOrCreateUserWithSlackUponInvitation
  include Interactor::Organizer

  organize Slack::FetchIdentity, Slack::FindOrCreateUser, Slack::AcceptInvitation
end
