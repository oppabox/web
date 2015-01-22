class Change < ActiveRecord::Base
	belongs_to  :order

	before_save :quantity_check
	before_create :validate_request

	scope :requested,						-> { where(status: STATUS_REQUEST) }
	scope :on_process,					-> { where(status: STATUS_ON_PROCESS) }
	scope :done,								-> { where(status: STATUS_DONE) }
	scope :rejected,						-> { where(status: STATUS_REJECT) }
	scope :cancelled,						-> { where(status: STATUS_CANCEL) }
	scope :on_delivery,					-> { where(status: STATUS_ON_DELIVERY) }

	STATUS_REQUEST = 0
	STATUS_ON_PROCESS = 1
	STATUS_DONE = 2
	STATUS_REJECT = 3
	STATUS_CANCEL = 4
	STATUS_ON_DELIVERY = 5

	STATUSES = {
		STATUS_REQUEST => "STATUS_CHANGE_REQUEST",
		STATUS_ON_PROCESS => "STATUS_CHANGE_ON_PROCESS",
		STATUS_DONE => "STATUS_CHANGE_DONE",
		STATUS_REJECT => "STATUS_CHANGE_REJECT",
		STATUS_CANCEL => "STATUS_CHANGE_CANCEL",
		STATUS_ON_DELIVERY => "STATUS_CHANGE_ON_DELIVERY"
	}

	REASONS = {
		0 => 'change_reasons0',
		1 => 'change_reasons1',
		2 => 'change_reasons2',
		3 => 'change_reasons3',
		4 => 'change_reasons4',
	}

	def quantity_check
		if self.quantity.nil? or self.quantity <= 0 
      return false
    end

    if self.order.nil? or self.quantity > self.order.quantity 
    	return false
    end
	end

	def validate_request
		if User.current.nil? 
			return false
		else
			user = User.current
			ids = []

			user.purchases.each do |p|
				ids += p.orders.pluck(:id)
			end

			unless ids.include?(self.order_id)
				return false
			end
		end
	end
end
