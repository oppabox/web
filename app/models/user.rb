class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :async #password reset

  def self.check_sign_params email, password, password_confirm = nil
    if password_confirm.nil?
      password_confirm = password
    end

    ret = Hash.new
    ret[:result] = true
    if email.match(Devise::email_regexp).nil?
      ret[:result] = false
      ret[:message] = I18n.t('usercheck_invalid_email')
    elsif password.length < 8
      ret[:result] = false
      ret[:message] = I18n.t('usercheck_password_short_length')
    elsif password != password_confirm
      ret[:result] = false
      ret[:message] = I18n.t('usercheck_password_confirm_not_equal')
    end

    ret
  end
end
