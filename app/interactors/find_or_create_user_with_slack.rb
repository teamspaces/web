class FindOrCreateUserWithSlack
  include Interactor::Organizer

  organize Slack::FetchIdentity, Slack::FindOrCreateUser
end
