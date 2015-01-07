ActiveAdmin.register_page "Dashboard" do
	
	content :title => "Dashboard" do

		columns do
			column do
				panel "Total" do
					status = Purchase::STATUSES
					table_for Purchase.where.not(status: [PURCHASE_ORDERING, PURCHASE_DONE]).group(:status).count do |p|
						for i in 1..(status.count - 2)
							column(status[i]) { |p| p[i] }
						end
					end
				end
			end #column
		end # colums


	# sidebar :help do
	#   ul do
	#     li "First Line of Help"
	#   end
	# end

	end
end