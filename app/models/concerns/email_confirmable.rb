module EmailConfirmable
  extend ActiveSupport::Concern

  included do
    after_update :generate_new_confirmation_token, if: :email_changed_before_ever_confirmed?
  end

  def confirmation_instructions_sent?
    self.confirmation_sent_at.present?
  end

  def email_confirmation_required?
    confirmation_required? || pending_reconfirmation?
  end

  def email_confirmed_ever?
    !(confirmed_at.nil? && unconfirmed_email.nil?)
  end

  def email_changed_before_ever_confirmed?
    allow_email_login && email_changed? && !email_confirmed_ever?
  end

  def generate_new_confirmation_token
    reload

    self.confirmation_token = nil
    generate_confirmation_token!
  end

  # overwrite devise confirmable
  def generate_confirmation_token
    super
    self.confirmation_sent_at = nil
  end

  def send_confirmation_instructions(opts={})
    unless @raw_confirmation_token
      generate_confirmation_token!
    end

    controller = opts[:controller]
    opts.delete(:controller)

    if controller.request.get?
      opts[:confirmation_url] = controller.url_for(controller.params
                                                             .permit!
                                                             .merge(confirmation_token: confirmation_token))
    else
      opts[:confirmation_url] = controller.root_subdomain_url(subdomain: controller.current_team.subdomain,
                                                              confirmation_token: confirmation_token)
    end

    opts[:to] = unconfirmed_email if pending_reconfirmation?
    send_devise_notification(:confirmation_instructions, @raw_confirmation_token, opts)

    self.confirmation_sent_at = Time.now.utc
    save(validate: false)
  end

  def confirmation_required?
    allow_email_login && super
  end

  def postpone_email_change?
    allow_email_login && email_confirmed_ever? && super
  end

  def reconfirmation_required?
    allow_email_login && super
  end
end

