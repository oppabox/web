ActiveAdmin.register_page "Dashboard" do
	
	content :title => "Dashboard" do

		columns do
			column do
				panel "Total" do
					status = Purchase::STATUSES
					status_exclude = [PURCHASE_ORDERING]
					table_for Purchase.where.not(status: status_exclude).group(:status).count do |p|
						for s in status
							# s : [0, '주문중']
							unless status_exclude.include? s[0]
								column(s[1]) { |p| p[s[0]] }
							end
						end
					end
				end
			end #column
			column do
				panel "Return" do
					status = Return::STATUSES
					table_for Return.group(:status).count do |r|
						for s in status
							column(s[1]) { |r| r[s[0]] }
						end
					end
				end
			end #column
		end # columns

	end
end