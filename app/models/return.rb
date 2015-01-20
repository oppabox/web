class Return < ActiveRecord::Base
	# :order_id, :quantity, :status, :reason, :reason_details, :sent, + personal info
	belongs_to  :order

	before_save :quantity_check
	before_create :validate_request

	scope :requested,							-> { where(status: STATUS_REQUEST) }
	scope :on_process,						-> { where(status: STATUS_ON_PROCESS) }
	scope :done,									-> { where(status: STATUS_DONE) }
	scope :rejected,							-> { where(status: STATUS_REJECT) }
	scope :cancelled,							-> { where(status: STATUS_CANCEL) }


	STATUS_REQUEST = 0
	STATUS_ON_PROCESS = 1
	STATUS_DONE = 2
	STATUS_REJECT = 3
	STATUS_CANCEL = 4

	STATUSES = {
		STATUS_REQUEST => "STATUS_REQUEST",
		STATUS_ON_PROCESS => "STATUS_ON_PROCESS",
		STATUS_DONE => "STATUS_DONE",
		STATUS_REJECT => "STATUS_REJECT",
		STATUS_CANCEL => "STATUS_CANCEL"
	}

	REASONS = {
		0 => 'return_model_reasons0',
		1 => 'return_model_reasons1',
		2 => 'return_model_reasons2',
		3 => 'return_model_reasons3',
		4 => 'return_model_reasons4',
		5 => 'return_model_reasons5',
		6 => 'return_model_reasons6',
		7 => 'return_model_reasons7',
		8 => 'return_model_reasons8'
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
