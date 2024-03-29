class CustomDeviseMailer < Devise::Mailer
  include Devise::Controllers::UrlHelpers

  helper :application
  default template_path: "devise/mailer" # use the devise views

  def confirmation_instructions(record, token, options={})
    @confirmation_url = options[:confirmation_url]

    options[:template_name] = if record.pending_reconfirmation?
      "reconfirmation_instructions"
    else
      "confirmation_instructions"
    end

    super
  end
end
