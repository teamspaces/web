class CustomDeviseMailerPreview < ActionMailer::Preview
  def confirmation_instructions
    CustomDeviseMailer.confirmation_instructions(User.last, "faketoken", {})
  end
end
