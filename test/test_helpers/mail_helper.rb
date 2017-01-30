module TestHelpers::MailHelper

  def mail_content(mail)
    mail.body.raw_source
  end

  def find_link_in_mail(mail)
    link = mail_content(mail).match(/href="(?<url>.+?)">/)[:url]
    link
  end

end
