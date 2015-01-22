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
				table class: 'table table-bordered option_table' do
					thead do
						th 'name'
						th 'type'
						th 'max_len'
						th 'eng_only'
						th 'name'
						th 'quan'
						th 'lim'
						th 'price_chn'
					end
					tbody do
						item.options.each do |o|
							if (cnt = o.option_items.count) == 0
								tr do
									td o.title
									td Option::TYPE[o.option_type]
									td o.option_type == OPTION_TYPE_STRING ? o.max_length : ''
									td o.option_type == OPTION_TYPE_STRING ? o.english_only : ''
									td colspan: 4
								end
							else
								o.option_items.each_with_index do |oi, idx|
									tr do
										if idx == 0
											td rowspan: cnt do o.title end
											td rowspan: cnt do Option::TYPE[o.option_type] end
											td rowspan: cnt do o.option_type == OPTION_TYPE_STRING ? o.max_length : '' end
											td rowspan: cnt do o.option_type == OPTION_TYPE_STRING ? o.english_only : '' end
											td oi.name
											td oi.quantity
											td oi.limited.to_s
											td oi.price_change
										else
											td oi.name
											td oi.quantity
											td oi.limited.to_s
											td oi.price_change
										end
									end
								end
							end
						end
					end
				end
			end #unless
		end


		column "" do |item|
			para link_to "수정", edit_admin_item_path(item.id), { :class => "btn btn-default" }
		end
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