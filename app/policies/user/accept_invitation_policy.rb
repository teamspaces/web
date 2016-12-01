class User::AcceptInvitationPolicy
  attr_reader :user, :invitation

  def initialize(user, invitation)
    @user = user
    @invitation = invitation
  end

  def destroy?
    owned_by_team?
  end

  private

    def owned_by_team?
      team == invitation.team
    end
end
