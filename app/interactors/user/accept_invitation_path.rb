class User::AcceptInvitationPath
  include Interactor

  def call
    @user = context.user
    @controller = context.controller

    @invitation = invitation_cookie.invitation
                  invitation_cookie.delete

    context.path = decide_path
  end

  def decide_path
    @invitation.present? ? accept_invitation_path : non_existing_invitation_path
  end

  def accept_invitation_path
    if user_accept_invitation_policy.matching?
      User::AcceptInvitation.call(user: @user, invitation: @invitation)

      add_flash_message("successfully_accepted_invitation")
      user_sign_in_path(team_to_redirect_to: @invitation.team)
    else
      add_flash_message("invitation_does_not_match_user")
      user_sign_in_path
    end
  end

  def non_existing_invitation_path
    add_flash_message("invitation_does_not_exist")
    user_sign_in_path
  end

  private

    def add_flash_message(translation_lookup)
      @controller.flash[:notice] = I18n.t(translation_lookup)
    end

    def user_sign_in_path(options)
      User::SignInPath.call({ user: @user, controller: @controller }.merge(options.to_h)).path
    end

    def user_accept_invitation_policy
      @user_accept_invitation_policy ||= User::AcceptInvitationPolicy.new(@user, @invitation)
    end

    def invitation_cookie
      @invitation_cookie ||= LoginRegisterFunnel::InvitationCookie.new(@controller.send(:cookies))
    end
end
