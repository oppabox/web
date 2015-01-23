ActiveAdmin.register Return do
	menu :parent => "Cancel/Return/Change"
	config.batch_actions = false
  config.sort_order = "created_at_desc"
	status_css = ['warning', 'yes', 'complete', 'error', '']

	scope proc{ "전체" }, :all, default: true
	scope proc{ I18n.t('STATUS_RETURN_REQUEST') }, :requested
	scope proc{ I18n.t('STATUS_RETURN_ON_PROCESS') }, :on_process
	scope proc{ I18n.t('STATUS_RETURN_DONE') }, :done
	scope proc{ I18n.t('STATUS_RETURN_REJECT') }, :rejected
	scope proc{ I18n.t('STATUS_RETURN_CANCEL') }, :cancelled


	################# change status #################
	collection_action :change_status, :method => :patch do
		r = Return.find(params[:form][:id])

		unless params[:form][:status] == r.status.to_s
			if params[:form][:status] == Return::STATUS_DONE.to_s
				r.request_done
			else
				r.status = params[:form][:status]
				r.save
			end
		end

		redirect_to :action => :index
	end

	################# index #################
	index do
		column :id
		column "접수상태" do |r|
			para status_tag(t(Return::STATUSES[r.status]), status_css[r.status])
		end
		column '상품명' do |r|
			para r.order.item.display_name
		end
		column "주문수량" do |r|
			para r.order.quantity
		end
		column "교환수량", :quantity
		column "교환이유구분" do |r|
			para t(Return::REASONS[r.reason])
		end
		column "교환이유", :reason_details
		column "신청자정보" do |r|
			para r.sender + ' (' + r.country + ')'
			para r.order.purchase.user.email
		end
		column "주소 / 도시 / 우편번호" do |r|
			para r.address
			para r.city
			para r.postcode
		end
		column "휴대번호",:phonenumber
    column "신청시간" do |c|
      para c.created_at.strftime("%Y-%m-%d")
    end
    column "처리시간" do |c|
      para (c.status == Return::STATUS_DONE or c.status == Return::STATUS_CANCEL) ? c.updated_at.strftime("%Y-%m-%d") : "처리중"
    end
		column "관리" do |r|
			render :partial => "/admin/change_status", :locals => { :id => r.id, :collection => t(Return::STATUSES.invert.keys), :data => r.status }
		end
	end

	filter :id
  filter :order_purchase_reference_number_eq, :as => :string, :label => "주문번호"
	filter :status, :as => :select, :collection => proc{ t(Return::STATUSES.invert.keys) }, :label => "접수상태"
	filter :reason, :as => :select, :collection => proc{ t(Return::REASONS.invert.keys) }, :label => "이유"
	filter :sender_eq, :as => :string, :label => '주문자 이름'
	filter :phonenumber_eq, :as => :string, :label => '휴대번호'
	filter :address_eq, :as => :string, :label => '주소'
	filter :country_eq, :as => :string, :label => '나라'
	filter :country_not_eq, :as => :string, :label => '나라(제외)'
  filter :created_at, :label => "신청시간"
  filter :updated_at, :label => "처리시간"

end
