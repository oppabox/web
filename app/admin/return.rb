ActiveAdmin.register Return do
	menu :parent => "Cancel/Return/Change"
	config.batch_actions = false
	status_css = ['warning', 'yes', 'complete', 'error', '']

	scope :all, default: true
	scope :requested
	scope :on_process
	scope :done
	scope :rejected
	scope :cancelled


	################# change status #################
	collection_action :change_status, :method => :patch do
		r = Return.find(params[:form][:id])

		unless params[:form][:status] == c.status.to_s
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
		column :status do |r|
			status_tag(Return::STATUSES[r.status], status_css[r.status])
		end
		column 'Product' do |r|
			r.order.item.display_name
		end
		column "Order quantity" do |r|
			r.order.quantity
		end
		column :quantity
		column :reason do |r|
			t(Return::REASONS[r.reason])
		end
		column :reason_details
		column "info" do |r|
			para r.sender + ' (' + r.country + ')'
			para r.order.purchase.user.email
		end
		column "address / city / postcode" do |r|
			para r.address
			para r.city
			para r.postcode
		end
		column :phonenumber
		column "Manage" do |r|
			render :partial => "/admin/change_status", :locals => { :id => r.id, :collection => Return::STATUSES.invert, :data => r.status }
		end
	end

	filter :id
	filter :status, :as => :select, :collection => Return::STATUSES.invert
	filter :reason, :as => :select, :collection => Return::REASONS.invert
	filter :sender_eq, :as => :string, :label => 'Sender'
	filter :phonenumber_eq, :as => :string, :label => 'phonenumber'
	filter :address_eq, :as => :string, :label => 'Address'
	filter :country_eq, :as => :string, :label => 'Country'
	filter :country_not_eq, :as => :string, :label => 'Country except'

end
