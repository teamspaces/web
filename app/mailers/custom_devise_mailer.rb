class CustomDeviseMailer < Devise::Mailer
  include Devise::Controllers::UrlHelpers

  helper :application
  default template_path: "devise/mailer" # use the devise views

  def confirmation_instructions(record, token, options={})
    options[:template_name] = record.pending_reconfirmation? ? "reconfirmation_instructions" : "confirmation_instructions"

    super
  end
end
