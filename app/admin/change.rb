ActiveAdmin.register Change do
	menu :parent => "Cancel/Return/Change"
	config.batch_actions = false
	status_css = ['warning', 'yes', 'complete', 'error', '', '']

	scope :all, default: true
	scope :requested
	scope :on_process
	scope :done
	scope :rejected
	scope :cancelled
	scope :on_delivery


	################# change status #################
	collection_action :change_status, :method => :patch do
		c = Change.find(params[:form][:id])
		c.status = params[:form][:status]
		c.save

		redirect_to :action => :index
	end

	################# index #################
	index do
		column :id
		column :status do |c|
			status_tag(Change::STATUSES[c.status], status_css[c.status])
		end
		column 'Product' do |c|
			c.order.item.display_name
		end
		column "Order quantity" do |c|
			c.order.quantity
		end
		column :quantity
		column :reason do |c|
			t(Change::REASONS[c.reason])
		end
		column :reason_details
		column "info" do |c|
			para c.sender + ' (' + c.country + ')'
			para c.order.purchase.user.email
		end
		column "address / city / postcode" do |c|
			para c.address
			para c.city
			para c.postcode
		end
		column :phonenumber
		column "Manage" do |c|
			render :partial => "/admin/change_status", :locals => { :id => c.id, :collection => Change::STATUSES.invert, :data => c.status }
		end
	end

	filter :id
	filter :status, :as => :select, :collection => Change::STATUSES.invert
	filter :reason, :as => :select, :collection => Change::REASONS.invert
	filter :sender_eq, :as => :string, :label => 'Sender'
	filter :phonenumber_eq, :as => :string, :label => 'phonenumber'
	filter :address_eq, :as => :string, :label => 'Address'
	filter :country_eq, :as => :string, :label => 'Country'
	filter :country_not_eq, :as => :string, :label => 'Country except'

end
