class Return < ActiveRecord::Base
	# :order_id, :quantity, :status, :reason, :reason_details, :sent, + personal info
	belongs_to  :order

	before_save :quantity_check

	STATUSES = {
		RETURN_REQUEST => "return_request",
		RETURN_ON_PROCESS => "return_on_process",
		RETURN_DONE => "return_done",
		RETURN_REJECT => "return_reject",
		RETURN_CANCEL => "return_cancel"
	}

	REASONS = {
		0 => "Please select the reason",
		1 => "No longer needed/wanted",
		2 => "Different from website description",
		3 => "Select options incorrectly",
		4 => "Damaged due to inappropriate packaging",
		5 => "Missed estimated delivery date",
		6 => "Different from what was ordered",
		7 => "Defective/Does not work properly",
		8 => "Etc."
	}

	def quantity_check
		if self.quantity.nil? or self.quantity < 0 
      self.quantity = 0
    end

    if self.order.nil? or self.quantity > self.order.quantity 
    	return false
    end
	end
end
