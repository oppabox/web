# clear
Shipping.all.each do |x|
	x.destroy
end

ItemShipping.all.each do |x|
	x.destroy
end

OrderShipping.all.each do |x|
	x.destroy
end

# domestic
a = Shipping.new
a.category = 0
a.name = 'FREE'
a.save

b = Shipping.new
b.category = 0
b.name = 'STANDARD'
b.threshold = 50000
b.save

# foreign
c = Shipping.new
c.category = 1
c.name = 'UPS'
c.save

d = Shipping.new
d.category = 1
d.name = 'EMS'
d.save

# set item
t = Shipping.where(:name => ['FREE', 'UPS', 'EMS'])
Item.all.each do |i|
	i.shippings = t
	i.save
end

Order.all.each do |o|
	if o.purchase.user.country == "KR"
		o.shipping = a
	else
		o.shipping = c
	end
	o.save
end