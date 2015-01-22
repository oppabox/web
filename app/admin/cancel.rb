ActiveAdmin.register Cancel do
	menu :parent => "Cancel/Return/Change"
	config.batch_actions = false
	status_css = ['warning', 'yes', 'complete', 'error', '']

	scope :all, default: true
	scope :requested
	scope :done
	scope :cancelled
	scope :rejected


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
		column :status do |c|
			status_tag(Cancel::STATUSES[c.status], status_css[c.status])
		end
		column 'Product' do |c|
			c.order.item.display_name
		end
		column "Order quantity" do |c|
			c.order.quantity
		end
		column :quantity
		column :reason do |c|
			t(Cancel::REASONS[c.reason])
		end
		column :reason_details
		column "user info" do |c|
			u = c.order.purchase.user
			para u.name + ' (' + u.country + ')'
			para u.email
		end
		column "phonenumber" do |c| 
			c.order.purchase.user.phonenumber
		end
		column "Manage" do |c|
			render :partial => "/admin/change_status", :locals => { :id => c.id, :collection => Cancel::STATUSES.invert, :data => c.status }
		end
	end

	filter :id
	filter :status, :as => :select, :collection => Cancel::STATUSES.invert
	filter :reason, :as => :select, :collection => Cancel::REASONS.invert
	filter :order_purchase_user_name_eq, :as => :string, :label => 'User name'
	filter :order_purchase_user_phonenumber_eq, :as => :string, :label => 'Phonenumber'
	filter :order_purchase_user_address_eq, :as => :string, :label => 'Address'
	filter :order_purchase_user_country_eq, :as => :string, :label => 'Country'
	filter :order_purchase_user_country_not_eq, :as => :string, :label => 'Country except'

end
