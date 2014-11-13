class UserMailer < ActionMailer::Base
  default from: "postmaster@oppabox.com"

  def password_reset(user)
    @user = user

    mail to: user.email,
         subject: "#{user.email}#{I18n.t('reset_password_mail_subject')}"
  end
end
