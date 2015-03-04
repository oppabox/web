ActiveAdmin.register Change do
	menu label: "교환", :parent => "취소/환불/교환"
	config.batch_actions = false
	# remove action items
  config.clear_action_items!
  config.sort_order = "created_at_desc"
	status_css = ['warning', 'yes', 'complete', 'error', '', '']

	scope proc{ "전체" }, :all, default: true
	scope proc{ I18n.t('STATUS_CHANGE_REQUEST') }, :requested
	scope proc{ I18n.t('STATUS_CHANGE_ON_PROCESS') }, :on_process
	scope proc{ I18n.t('STATUS_CHANGE_DONE') }, :done
	scope proc{ I18n.t('STATUS_CHANGE_REJECT') }, :rejected
	scope proc{ I18n.t('STATUS_CHANGE_CANCEL') }, :cancelled
	scope proc{ I18n.t('STATUS_CHANGE_ON_DELIVERY') }, :on_delivery

	scope_to :current_admin_user

	################# change status #################
	collection_action :change_status, :method => :patch do
		c = Change.find(params[:form][:id])
		c.status = params[:form][:status]
		c.save

		redirect_to :action => :index
	end

	################# index #################
	index :title => '교환' do
		column :id
    column "주문번호" do |c|
      para c.order.purchase.reference_number
    end
		column "접수상태" do |c|
			para status_tag(t(Change::STATUSES[c.status]), status_css[c.status])
		end
		column "상품명" do |c|
			para c.order.item.display_name
		end
		column "주문수량" do |c|
			para c.order.quantity
		end
		column "교환수량", :quantity
		column "교환이유구분" do |c|
			para t(Change::REASONS[c.reason])
		end
		column "교환이유",:reason_details
		column "신청자정보" do |c|
			para c.sender + ' (' + c.country + ')'
			para c.order.purchase.user.email
		end
		column "주소 / 도시 / 우편번호" do |c|
			para c.address
			para c.city
			para c.postcode
		end
		column "휴대번호", :phonenumber
    column "신청시간" do |c|
       para c.created_at.strftime("%Y-%m-%d")
    end
    column "처리시간" do |c|
       para (c.status == Change::STATUS_DONE or c.status == Change::STATUS_CANCEL) ? c.updated_at.strftime("%Y-%m-%d") : "진행중"
    end 
		column "관리" do |c|
			render :partial => "/admin/cancels/change_status", :locals => { :id => c.id, :collection => Change::STATUSES.invert.collect { |x| [I18n.t(x[0]), x[1]] }, :data => c.status }
		end
	end

	filter :id
  filter :order_purchase_reference_number_eq, :as => :string, :label => "주문번호"
	filter :status, :as => :select, :collection => proc { Change::STATUSES.invert.map { |a,b| [t(a),b] } }, :label => "접수상태"
	filter :reason, :as => :select, :collection => proc { Change::REASONS.invert.map { |a,b| [t(a),b] } }, :label => "이유"
	filter :sender_eq, :as => :string, :label => '신청자 이름'
	filter :phonenumber_eq, :as => :string, :label => '휴대번호'
	filter :address_eq, :as => :string, :label => '주소'
	filter :country_eq, :as => :string, :label => '나라'
	filter :country_not_eq, :as => :string, :label => '나라(제외)'
  filter :created_at, :label => "신청시간"
  filter :updated_at, :label => "처리시간"
end
