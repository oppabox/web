class Cancel < ActiveRecord::Base
	belongs_to  :order

	before_save :quantity_check
	before_create :validate_request

	scope :requested,						-> { where(status: STATUS_REQUEST) }
	scope :done,								-> { where(status: STATUS_DONE) }
	scope :cancelled,						-> { where(status: STATUS_CANCEL) }

	STATUS_REQUEST = 0
	STATUS_DONE = 1
	STATUS_CANCEL = 2

	STATUSES = {
		STATUS_REQUEST => "STATUS_REQUEST",
		STATUS_DONE => "STATUS_DONE",
		STATUS_CANCEL => "STATUS_CANCEL"
	}

	REASONS = {
		0 => 'cancel_reasons0',
		1 => 'cancel_reasons1',
		2 => 'cancel_reasons2',
		3 => 'cancel_reasons3'
	}

	def quantity_check
		if self.quantity.nil? or self.quantity < 0 
      self.quantity = 0
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

	def request_done
		self.status = STATUS_DONE
		self.order.cancel_transaction(self.quantity)
		self.save
	end
end
