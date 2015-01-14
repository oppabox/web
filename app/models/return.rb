class Return < ActiveRecord::Base
	# :order_id, :quantity, :status, :reason, :reason_details, :sent, + personal info
	belongs_to  :order

	before_save :quantity_check
	before_create :validate_request

	STATUSES = {
		RETURN_REQUEST => "return_request",
		RETURN_ON_PROCESS => "return_on_process",
		RETURN_DONE => "return_done",
		RETURN_REJECT => "return_reject",
		RETURN_CANCEL => "return_cancel"
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

end
