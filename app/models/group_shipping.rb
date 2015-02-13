class GroupShipping < ActiveRecord::Base
	belongs_to	:admin_user
	has_many    :items
end
