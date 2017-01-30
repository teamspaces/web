class CustomDeviseMailerPreview < ActionMailer::Preview
  def confirmation_instructions
    CustomDeviseMailer.confirmation_instructions(User.last, "fake_token", {confirmation_url: "www.lvh.me"})
  end

  def reset_password_instructions
    CustomDeviseMailer.reset_password_instructions(User.last, "fake_token",, {})
  end

  def password_change
    CustomDeviseMailer.password_change(User.last, {})
  end
end
