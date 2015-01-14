ActiveAdmin.register Box do
	config.batch_actions = false

	index do
		column :id
		column "Image" do |b|
			tag :img, :src => "/images/box/#{b.path}.jpg", :width => "100px", :height => "100px"
		end
		column :display_name
		column :path
		column :opened
		column :created_at
		column "" do |b|
			link_to "Show", { :action => :show, :id => b.id }, { :class => 'btn-normal' }
		end
	end

	show do
		attributes_table do
			row :id
			row :display_name
			row :path
			row :opened
			row :created_at
		end #attr_table

		panel "Item Details" do
			table_for Box.find(params[:id]).items do |item|
				column('Image') do |item|
					tag :img, :src => "/images/box/#{item.path}.jpg", :width => "100px", :height => "100px"
				end
				column('Name') { |item| item.item_names.where(locale: "ko").take.name }
				column('Original Price') { |item| item.original_price }
				column('Sale Price') { |item| item.sale_price }
				column('Quantity') { |item| item.quantity }
				column('limited') { |item| item.limited }
				column('Periodic') { |item| item.periodic }
				column('Opened') { |item| item.opened }
				column('Weight') { |item| item.weight }
				column('Options') do |item|
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
			end #table_for
		end #panel

	end
end