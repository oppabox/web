ActiveAdmin.register Return do
	config.batch_actions = false
	status_css = ['warning', 'yes', 'complete', 'error', '']

	################# change status #################
	collection_action :change_status, :method => :patch do
		r = Return.find(params[:return][:id])
		r.status = params[:return][:status]
		r.save

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
			Return::REASONS[r.reason]
		end
		column :reason_details
		column :sender
		column :phonenumber
		column :postcode
		column :address
		column :city
		column :state
		column :country
		column "Manage" do |r|
			render :partial => "change_status", :locals => { :id => r.id, :collection => Return::STATUSES.invert, :data => r.status }
		end
	end

	filter :id
	filter :status, :as => :select, :collection => Return::STATUSES.invert
	filter :reason, :as => :select, :collection => Return::REASONS.invert
	filter :sender
	filter :phonenumber
	filter :postcode
	filter :address
	filter :city
	filter :state
	filter :country

end