class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, :omniauth_providers => [:facebook]

  has_many :purchases
  has_many :baskets

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
        # if auth.provider == "weibo"
        #   "#{auth.uid}@weibo.com"
        # else
        #   auth.info.email
        # end
      user.password = Devise.friendly_token[0,20]
      user.name = auth.info.name   # assuming the user model has a name
      #user.image = auth.info.image # assuming the user model has an image
    end
  end

  def self.new_with_session(params, session)
    # super.tap do |user|
    #   if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
    #     user.email = data["email"] if user.email.blank?
    #   end
    # end
    def self.new_with_session(params, session)
      if session["devise.user_attributes"]
        new(session["devise.user_attributes"], without_protection: true) do |user|
          user.attributes = params
          user.valid?
        end
      else
        super
      end
    end
  end

  def orders
    p = self.purchase
    p.nil? ? [] : p.orders
  end

  def purchase
    self.purchases.where(status: "ordering").take
  end

  def send_password_reset
    enc = Devise.token_generator.generate(self.class, :reset_password_token)

    self.reset_password_token   = enc[1]
    self.reset_password_sent_at = Time.now.utc
    self.save!

    UserMailer.password_reset(self).deliver
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
end
