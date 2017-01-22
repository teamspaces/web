class CustomDeviseMailer < Devise::Mailer
  include Devise::Controllers::UrlHelpers

  helper :application
  default template_path: "devise/mailer" # use the devise views

  def confirmation_instructions(record, token, options={})
      confirmation_template = "confirmation_instructions"
    reconfirmation_template = "reconfirmation_instructions"

    options[:template_name] = record.pending_reconfirmation? ? reconfirmation_template : confirmation_template

    super
  end
end
