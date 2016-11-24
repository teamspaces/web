class LoginOrRegisterWithSlackUponInvitation
  include Interactor::Organizer

  organize Slack::FetchIdentity, Slack::LoginOrRegister, Slack::AcceptInvitation
end
