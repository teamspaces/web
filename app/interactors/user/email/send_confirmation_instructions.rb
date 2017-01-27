class User::Email::SendConfirmationInstructions
  include Interactor

  def call
    @user = context.user
    @controller = context.controller

    send_mail && save_sent_at
  end

  def send_mail
    options = { confirmation_url: confirmation_url }
    options[:to] = @user.unconfirmed_email if @user.pending_reconfirmation?

    @user.send(:send_devise_notification, :confirmation_instructions, @user.confirmation_token, options)
  end

  def save_sent_at
    @user.confirmation_sent_at = Time.now.utc
    @user.save(validate: false)
  end

  private

    def confirmation_url
      if current_url_is_valid_email_link?
        current_url_with_confirmation_token
      else
        root_subdomain_url_with_confirmation_token
      end
    end

    def current_url_is_valid_email_link?
      @controller.request.get?
    end

    def current_url_with_confirmation_token
      @controller.url_for(@controller.params.permit!
                                     .merge(confirmation_token: @user.confirmation_token))
    end

    def root_subdomain_url_with_confirmation_token
      @controller.root_subdomain_url(subdomain: @controller.current_team.subdomain,
                                     confirmation_token: @user.confirmation_token)
    end
end
