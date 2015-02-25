class UserMailer < ActionMailer::Base
	default from: "noreply@oppabox.com"

	def password_reset(user)
		@user = user

		mail to: user.email,
			subject: "#{user.email}#{I18n.t('reset_password_mail_subject')}"
	end

	# def test_mail
	# 	emails = User.where.not(email: nil).pluck(:email)

	# 	mail( to: emails, subject: 'Welcome!' )
	# end
	def test_mail
		email = "dane2522@gmail.com"

		mail( to: email, subject: 'Welcome!' )
	end
end
