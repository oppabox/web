class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, :omniauth_providers => [:facebook, :twitter]

  has_many :purchases
  has_many :baskets

  def orders
    p = self.purchase
    p.nil? ? [] : p.orders.where(deleted: false)
  end

  def purchase
    self.purchases.where(status: PURCHASE_ORDERING).take
  end

  def purchased_find purchase_id
    self.purchases.where(id: purchase_id).where.not(status: PURCHASE_ORDERING).take
  end

  def send_password_reset
    enc = Devise.token_generator.generate(self.class, :reset_password_token)

    self.reset_password_token   = enc[1]
    self.reset_password_sent_at = Time.now.utc
    self.save!

    UserMailer.password_reset(self).deliver
  end

  def self.send_test_mail
    UserMailer.test_mail().deliver
  end

  def self.check_sign_params email, password = nil, password_confirm = nil
    if password.nil?
      password = "password123" #Temporary password
    end
    if password_confirm.nil?
      password_confirm = password
    end

    ret = Hash.new
    ret[:result] = true
    if email.match(Devise::email_regexp).nil?
      ret[:result] = false
      ret[:message] = I18n.t('usercheck_invalid_email')
    elsif password.length < 4
      ret[:result] = false
      ret[:message] = I18n.t('usercheck_password_short_length')
    elsif password != password_confirm
      ret[:result] = false
      ret[:message] = I18n.t('usercheck_password_confirm_not_equal')
    end
    ret
  end

  def self.current
    Thread.current[:user]
  end
  def self.current=(user)
    Thread.current[:user] = user
  end
end
