ActiveAdmin.register Item do
	menu :priority => 6

	index do
		column :id
		column "Image" do |i|
			tag :img, :src => "/images/box/#{i.path}.jpg", :width => "100px", :height => "100px"
		end
		column :box
		column :original_price
		column :sale_price
		column :quantity do |i|
			if i.limited
				i.quantity
			else
				'unlimited'
			end
		end
		column :periodic
		column :weight
		column :buy_limit	
		column "Options" do |item|
			unless item.options.count == 0
				table_for item.options do |o|
					column('name') { |o| o.title }
					column('type') { |o| Option::TYPE[o.option_type] }
					column('max_length') { |o| o.option_type == OPTION_TYPE_STRING ? o.max_length : '' }
					column('english_only') { |o| o.option_type == OPTION_TYPE_STRING ? o.english_only : '' }
					column('others(quantity / limited / price_change)') do |o|
						unless o.option_items.count == 0
							table_for o.option_items do |oi|
								column('name') { |oi| oi.name}
								column('quantity') { |oi| oi.quantity }
								column('limited') { |oi| oi.limited.to_s }
								column('price change') { |oi| oi.price_change }
							end #table_for
						end #unless
					end #column
				end #table_for
			end #unless
		end
		actions
	end

	filter :id
	filter :box
	filter :original_price
	filter :sale_price
	filter :quantity
	filter :limited
	filter :periodic
	filter :weight
	filter :buy_limit
end