ActiveAdmin.register_page "Dashboard" do
	menu :priority => 1
	content :title => "Dashboard" do
		render "dashboard"
	end

	################# change status #################
	page_action :get_all_statistic, :method => :post do

		now = Date.current()
		date_from = Date.strptime(params[:date_from], "%Y-%m-%d")
		date_to = Date.strptime(params[:date_to], "%Y-%m-%d") + 1

		date_from = "P" + date_from.strftime("%Y%m%d")
		date_to = "P" + date_to.strftime("%Y%m%d")

		if ActiveRecord::Base::connection.instance_values["config"][:adapter] == "mysql2"
			# for mysql
			res = current_admin_user.orders.paid
			.where("purchases.reference_number >= ? AND purchases.reference_number <= ?", date_from, date_to)
			.group("SUBSTRING(purchases.reference_number, 2, 8)")
			.sum("orders.quantity")
		else
			# for sqlite
			res = current_admin_user.orders.paid
			.where("purchases.reference_number >= ? AND purchases.reference_number <= ?", date_from, date_to)
			.group("SUBSTR(purchases.reference_number, 2, 8)")
			.sum("orders.quantity")
		end

		res.each do |data|
			puts data
		end
		
		render json: res
	end
end