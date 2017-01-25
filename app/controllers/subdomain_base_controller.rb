class SubdomainBaseController < ApplicationController
  before_action :verify_team_membership, :verify_email_confirmed

  helper_method :current_team
  def current_team
    subdomain_team
  end

  private

    def verify_team_membership
      unless current_team && TeamPolicy.new(pundit_user, current_team).read?
        redirect_to root_url(subdomain: ENV["DEFAULT_SUBDOMAIN"])
      end
    end

    def verify_email_confirmed
      unless UserPolicy.new(pundit_user, current_user).email_verified?
        User::Email::SendConfirmationInstructions.call(user: user)
        #if current_user.email_confirmation_required? && current_user.confirmation_sent_at.nil?
        #   current_user.generate_confirmation_token
        #   current_user.send_confirmation_instructions(url_to_redirect_to: url_for(params.permit!.merge(confirmation_token: "hello")))
        #end

        redirect_to new_user_email_confirmation_path
      end
    end

    def pundit_user
      DefaultContext.new(current_user, current_team)
    end
end
