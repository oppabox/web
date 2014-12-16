class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  # protect_from_forgery with: :exception

  before_action :set_locale, :current_translations
  def set_locale
    locale = cookies[:locale].to_s || I18n.default_locale.to_s
    if !["ko", "en", "cn", "ja"].include?(locale)
      I18n.locale = I18n.default_locale
    else
      I18n.locale = locale
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

  def input_option_validation
    #validate params[:option_items]
    target_item = Item.where(:id => params[:item_id]).take
    target_options = target_item.options.map{|x| x.id.to_s}.sort

    if (target_options.size > 0) 
      if params[:option_items].nil?
        render :nothing => true, :status => 406
      else
        input_options = params[:option_items].map{|x,y| x.to_s}.sort
        if input_options != target_options
          render :nothing => true, :status => 406
        end
      end
    end
  end
end
