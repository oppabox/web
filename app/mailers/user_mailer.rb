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
	def purchase_success_mail(purchase,user)
		name = user.name
		email = user.email
		@purchase = purchase
		@user = user

		mail( to: email, subject: "#{name}, Thank you for purchasing !!" )
	end

	def sign_up_mail(user)
		@user = user
		mail( to: user.email, subject: "Thank you for sign up !!")
	end

end
