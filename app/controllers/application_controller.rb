class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  # protect_from_forgery with: :exception

  before_action :set_locale, :current_translations
  def set_locale
    I18n.locale = cookies[:locale] || I18n.default_locale
    if !["ko", "en", "cn", "ja"].include?(I18n.locale.to_s)
      I18n.locale = I18n.default_locale
    end
  end

  def current_translations
    translations ||= I18n.backend.send(:translations)
    @current_translations = translations[cookies[:locale]] || translations[I18n.default_locale]

  end

  def login_check
    if !user_signed_in? 
      redirect_to "/home/login"
    end
  end
  
  def login_check_ajax
    if !user_signed_in? 
      render :nothing => true, :status => 401
    end
  end
end
