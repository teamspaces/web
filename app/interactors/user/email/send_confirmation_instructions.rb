class User::Email::SendConfirmationInstructions
  include Interactor

  def call
    @user = context.user
    @controller = context.controller

    send_mail && save_sent_at
  end

  def send_mail
    options = { confirmation_url: confirmation_url_from_last_controller_action }
    options[:to] = @user.unconfirmed_email if @user.pending_reconfirmation?

    @user.send(:send_devise_notification, :confirmation_instructions, @user.confirmation_token, options)
  end

  def save_sent_at
    @user.confirmation_sent_at = Time.now.utc
    @user.save(validate: false)
  end

  private

    def confirmation_url_from_last_controller_action
      if @controller.request.get?
        @controller.url_for(@controller.params.permit!.merge(confirmation_token: @user.confirmation_token))
      else
        @controller.root_subdomain_url(subdomain: @controller.current_team.subdomain, confirmation_token: @user.confirmation_token)
      end
    end
end
