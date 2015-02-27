ActiveAdmin.register Cancel do
	menu label: "취소", :parent => "취소/환불/교환"
	config.batch_actions = false
	# remove action items
  config.clear_action_items!
  config.sort_order = "created_at_desc"
	status_css = ['warning', 'yes', 'complete', 'error', '']

	scope proc{ "전체" }, :all, default: true
	scope proc{ I18n.t('STATUS_CANCEL_REQUEST')  }, :requested
	scope proc{ I18n.t('STATUS_CANCEL_DONE')}, :done
	scope proc{ I18n.t('STATUS_CANCEL_CANCEL') }, :cancelled
	scope proc{ I18n.t('STATUS_CANCEL_REJECT') }, :rejected

	scope_to :current_admin_user

	################# change status #################
	collection_action :change_status, :method => :patch do
		c = Cancel.find(params[:form][:id])
		
		unless params[:form][:status] == c.status.to_s
			if params[:form][:status] == Cancel::STATUS_DONE.to_s
				c.request_done
			else
				c.status = params[:form][:status]
				c.save
			end
		end

		redirect_to :action => :index
	end

	################# index #################
	index :title => '취소' do
		render partial: "index", :locals => { :status_css => status_css }
	end

	

	filter :id
  filter :order_purchase_reference_number_eq, :as => :string, :label => '주문번호'
	filter :status, :as => :select, :collection => proc { Cancel::STATUSES.invert.map { |a,b| [t(a),b] } }, :label => '접수상태'
	filter :reason, :as => :select, :collection => proc { Cancel::REASONS.invert.map { |a,b| [t(a),b] } }, :label => '이유'
	filter :order_purchase_user_name_eq, :as => :string, :label => '주문자 이름'
	filter :order_purchase_user_phonenumber_eq, :as => :string, :label => '휴대번호'
	filter :order_purchase_user_address_eq, :as => :string, :label => '주소'
	filter :order_purchase_user_country_eq, :as => :string, :label => '나라'
	filter :order_purchase_user_country_not_eq, :as => :string, :label => '나라(제외)'
  filter :created_at, :label => "신청시간"
  filter :updated_at, :label => "처리시간"

  controller do
  	def scoped_collection
    	super
    end
  end

end
