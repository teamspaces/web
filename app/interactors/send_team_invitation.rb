class SendTeamInvitation
  include Interactor

  def call
    InvitationMailer.join_team(context.invitation).deliver_later
  end
end



