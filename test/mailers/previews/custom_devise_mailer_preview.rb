class CustomDeviseMailerPreview < ActionMailer::Preview
  def confirmation_instructions
    user = User.last

    CustomDeviseMailer.confirmation_instructions(user, user.confirmation_token, {confirmation_url: "www.lvh.me"})
  end

  def reset_password_instructions
    user = User.last

    CustomDeviseMailer.reset_password_instructions(user, user.reset_password_token, {})
  end

  def password_change
    CustomDeviseMailer.password_change(User.last, {})
  end
end
