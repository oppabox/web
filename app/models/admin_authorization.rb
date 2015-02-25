class AdminAuthorization < ActiveAdmin::AuthorizationAdapter
	
	def authorized? action, subject = nil
		if user.master
			true
		else
			case subject
			when normalized(Box)
				if action == :update || action == :destroy
					user.boxes.include?(subject)
				else
					true
				end
			when normalized(Item)
				if action == :update || action == :destroy
					user.items.include?(subject)
				else
					true
				end
			when normalized(Purchase)
				if action == :update || action == :destroy
					user.purchases.include?(subject)
				else
					true
				end
			when normalized(Cancel)
				if action == :update || action == :destroy
					user.cancels.include?(subject)
				else
					true
				end
			when normalized(Return)
				if action == :update || action == :destroy
					user.returns.include?(subject)
				else
					true
				end
			when normalized(Change)
				if action == :update || action == :destroy
					user.changes.include?(subject)
				else
					true
				end
			when normalized(GroupShipping)
				if action == :update || action == :destroy
					user.group_shippings.include?(subject)
				else
					true
				end
			when ActiveAdmin::Page
				subject.name == "Dashboard"
			when normalized(User), normalized(AdminUser), ActiveAdmin::Comment, normalized(Order)
				# for only master admin user
				false
			else
				true
			end
		end
	end

end