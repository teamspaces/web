class User::AcceptInvitationURL
  include Interactor

  def call
    @user = context.user
    @controller = context.controller

    @invitation = invitation_cookie.invitation
                  invitation_cookie.delete

    context.url = accept_invitation_url
  end

  def accept_invitation_url
    if user_accept_invitation_policy.matching?
      User::AcceptInvitation.call(invited_user: @user, invitation: @invitation)

      add_flash_message("successfully_accepted_invitation")
      user_sign_in_url_decider(user: @user, team_to_redirect_to: @invitation.team).url
    else
      add_flash_message("invitation_does_not_match_user")
      user_sign_in_url_decider(user: @user).url
    end
  end

  private

    def user_accept_invitation_policy
      @user_accept_invitation_policy ||= User::AcceptInvitationPolicy.new(@user, @invitation)
    end

    def invitation_cookie
      @invitation_cookie ||= LoginRegisterFunnel::BaseController::InvitationCookie.new(@controller.send(:cookies))
    end

    def add_flash_message(translation_lookup)
      @controller.flash[:notice] = I18n.t(translation_lookup)
    end

    def user_sign_in_url_decider(options)
      User::SignInUrlDecider.call({controller: @controller }.merge(options))
    end
end
