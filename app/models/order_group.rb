# this class is used to utilize same functions of Order class
# even though this class has multiple Order instances
class OrderGroup
	def orders=(orders)
		@orders = orders
	end

  def orders
    @orders
  end

	def empty?
		@orders.empty?
	end

  def ids
    ids = []
    @orders.each do |o|
      ids << o.id
    end
    return ids
  end

	def items
    ids = []
    @orders.each do |o|
      ids << o.item.id
    end
		Item.where(id: ids)
	end

	def final_order_price
		sum = 0
		# first get sum of items
		sum += self.product_price
		# add shipping fee
    sum += self.get_delivery_fee
    return sum
  end

  def product_price
    sum = 0
    # first get sum of items
    @orders.each do |o|
      sum += o.total_price * o.quantity
    end
    return sum
  end

  def get_delivery_fee
  	if @orders.empty?
  		return nil
  	else
	  	name = @orders.first.shipping.name
	  	country = @orders.first.purchase.user.country
	  	
	  	pXq = 0
	  	weights = 0
	  	quantities = 0
	  	@orders.each do |o|
	  		pXq += o.total_price * o.quantity
	  		weights += o.item.weight
	  		quantities += o.quantity
	  	end

	    fee = Shipping.calculate_box_delivery name, country, pXq, weights, quantities
	    return fee.ceil
	  end
  end

  def self.grouping orders
  	# rtn: array of OrderGroup
  	rtn = []
  	# sort
  	orders = orders.includes(:item).order("items.group_shipping_id")
  	group_ids = orders.pluck("items.group_shipping_id")

  	idx = 0
  	while idx < group_ids.length
  		gid = group_ids[idx]

  		if gid.nil?
  			group = OrderGroup.new
  			# no group
  			group.orders = [ orders[idx] ]
  			idx += 1

  			rtn << group
  		else
  			# has group
  			# hash: hash of order array with key of shipping_id
  			# ex) { 1 => [o1, o2] }
  			hash = Hash.new
  			# find same gids
  			while gid == group_ids[idx]
  				# find shipping id
  				shipping_id = orders[idx].shipping.id
  				# put at hash
  				hash[shipping_id] ||= []
  				hash[shipping_id] << orders[idx]
  				idx += 1
  			end
  			# extract values of hash
  			# and convert them as OrderGroup
  			hash.values.each do |o_arr|
  				group = OrderGroup.new
  				group.orders = o_arr
  				rtn << group
  			end
  		end
  	end
  	
  	return rtn
  end
end