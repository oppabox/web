ActiveAdmin.register Cancel do
	menu :parent => "Cancel/Return/Change"
	config.batch_actions = false
  config.sort_order = "created_at_desc"
	status_css = ['warning', 'yes', 'complete', 'error', '']

	scope proc{ "전체" }, :all, default: true
	scope proc{ I18n.t('STATUS_CANCEL_REQUEST')  }, :requested
	scope proc{ I18n.t('STATUS_CANCEL_DONE')}, :done
	scope proc{ I18n.t('STATUS_CANCEL_CANCEL') }, :cancelled
	scope proc{ I18n.t('STATUS_CANCEL_REJECT') }, :rejected


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
	index do
		column :id
    column "주문번호" do |c|
      para c.order.purchase.reference_number
    end
		column "접수상태" do |c|
			para status_tag(t(Cancel::STATUSES[c.status]), status_css[c.status])
		end
		column '상품명' do |c|
			para c.order.item.display_name
		end
		column "주문수량" do |c|
			para c.order.quantity
		end
		column "취소수량",:quantity
		column "취소이유구분" do |c|
			para t(Cancel::REASONS[c.reason])
		end
		column "취소이유",:reason_details
		column "신청자정보" do |c|
			u = c.order.purchase.user
			para u.name + ' (' + u.country + ')'
			para u.email
		end
		column "휴대번호" do |c| 
			para c.order.purchase.user.phonenumber
		end
    column "신청시간" do |c|
      para c.created_at.strftime("%Y-%m-%d")
    end
    column "처리시간" do |c|
      para (c.status == Cancel::STATUS_DONE or c.status == Cancel::STATUS_CANCEL) ? c.updated_at.strftime("%Y-%m-%d") : "심사중"
    end
		column "관리" do |c|
			render :partial => "/admin/change_status", :locals => { :id => c.id, :collection => t(Cancel::STATUSES.invert.keys[c.status]), :data => c.status }
		end
	end

	filter :id
  filter :order_purchase_reference_number_eq, :as => :string, :label => '주문번호'
	filter :status, :as => :select, :collection => proc{ t(Cancel::STATUSES.invert.keys) }, :label => '접수상태'
	filter :reason, :as => :select, :collection => proc{ t(Cancel::REASONS.invert.keys) }, :label => '이유'
	filter :order_purchase_user_name_eq, :as => :string, :label => '주문자 이름'
	filter :order_purchase_user_phonenumber_eq, :as => :string, :label => '휴대번호'
	filter :order_purchase_user_address_eq, :as => :string, :label => '주소'
	filter :order_purchase_user_country_eq, :as => :string, :label => '나라'
	filter :order_purchase_user_country_not_eq, :as => :string, :label => '나라(제외)'
  filter :created_at, :label => "신청시간"
  filter :updated_at, :label => "처리시간"

end
