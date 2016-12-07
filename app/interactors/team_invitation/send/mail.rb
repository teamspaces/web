class TeamInvitation::Send::Mail
  include Interactor

  def call
    InvitationMailer.join_team(context.invitation).deliver_later
  end
end
