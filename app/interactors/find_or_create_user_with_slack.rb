class FindOrCreateUserWithSlack
  include Interactor::Organizer

  organize Slack::FetchIdentity, User::FindOrCreateUserFromSlackIdentity
end
