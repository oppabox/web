class AdminAuthorization < ActiveAdmin::AuthorizationAdapter
	
	def authorized? action, subject = nil
		true
	end

end