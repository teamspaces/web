class SubdomainBaseController < ApplicationController
  before_action :verify_team_membership, :verify_email_confirmed

  AVATAR_USERS_TO_SHOW = 3

  helper_method :current_team
  def current_team
    subdomain_team
  end

  helper_method :avatar_users
  def avatar_users
    @avatar_user_ids ||=
      user_ids = current_team.users
                             .limit(100)
                             .pluck(:id)
                             .sample(AVATAR_USERS_TO_SHOW)

    @avatar_users ||= User.where(id: @avatar_user_ids).all
  end

  helper_method :number_of_unseen_avatars
  def number_of_unseen_avatars
    @number_of_unseen_avatars ||=
      [(current_team.users.count - AVATAR_USERS_TO_SHOW), 0].max
  end

  private

    def verify_team_membership
      unless current_team && TeamPolicy.new(pundit_user, current_team).read?
        redirect_to root_url(subdomain: ENV["DEFAULT_SUBDOMAIN"])
      end
    end

    def verify_email_confirmed
      unless UserPolicy.new(pundit_user, current_user).email_verified?
        User::Email::SendConfirmationInstructions.call(user: current_user, controller: self) unless current_user.confirmation_instructions_sent?

        redirect_to new_user_email_confirmation_path
      end
    end

    def pundit_user
      DefaultContext.new(current_user, current_team)
    end
end
