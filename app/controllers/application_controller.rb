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
    validate_option_items = true
    validate_option_item_quantity = true
    target_item = Item.where(:id => params[:item_id]).take
    target_options = target_item.options.map{|x| x.id.to_s}.sort


    if (target_options.size > 0) 
      if params[:option_items].nil?
        render :nothing => true, :status => 406
        validate_option_items = false
      else
        input_options = params[:option_items].map{|x,y| x.to_s}.sort
        if input_options != target_options
          render :nothing => true, :status => 406
          validate_option_items = false
        end
      end
    end

    #validate options quantities
    if validate_option_items
      if !params[:option_items].nil?
        params[:option_items].each do |x, y|
          o = OptionItem.where(:id => y).take
          if !o.nil? and (o.quantity < params[:quantity].to_i)
            #TODO : HTTP STATUS MAY NOT BE CORRECT.
            render :text => t('over_quantity'), :status => 406 
            validate_option_item_quantity = false
            break
          end
        end
      end
    end

    #validate item quantity
    if validate_option_items and validate_option_item_quantity
      if (target_item.limited == true) and ( params[:quantity].to_i > target_item.quantity)
        render :text => t('over_quantity'), :status => 406 
      end
    end
  end
end
