class LoginOrRegisterWithSlack
  include Interactor::Organizer

  organize Slack::FetchIdentity, Slack::LoginOrRegister
end
