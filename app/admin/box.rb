ActiveAdmin.register Box do
	menu :priority => 5
	config.batch_actions = false

	################# new ##################
	form :partial => "new"

	collection_action :add_item, :method => :post do
		@id = params[:cnt]
		respond_to do |format|
			format.js
		end
	end

	collection_action :add_option, :method => :post do
		@id = params[:cnt]
		@item_id = params[:item_id]
		respond_to do |format|
			format.js
		end
	end

	collection_action :add_option_item, :method => :post do
		@option_id = params[:option_id]
		@item_id = params[:item_id]
		@cnt = params[:cnt]

		respond_to do |format|
			format.js
		end
	end

	collection_action :create, :method => :post do
		data = params[:box]

		item_prefix = 'item'
		option_prefix = 'option'
		option_item_prefix = 'item'
		
		# create box
		box = Box.new
		box.display_name = data['display_name']
		box.path = data['display_name'].gsub(" ", "_").downcase
		box.opened = data['opened'] == '1' ? true : false
		box.save

		# create item
		item_counter = 1
		while !data[item_prefix + item_counter.to_s].nil?
			item_data = data[item_prefix + item_counter.to_s]
			item = Item.new

			item.box = box
			item.path = item_data['path']
			item.original_price = item_data['original_price']
			item.sale_price = item_data['sale_price']
			item.quantity = item_data['quantity']
			item.weight = item_data['weight']
			item.buy_limit = item_data['buy_limit']
			item.show_original_price = item_data['show_original_price'] == '1' ? true : false
			item.limited = item_data['limited'] == '1' ? true : false
			item.periodic = item_data['periodic'] == '1' ? true : false
			item.opened = item_data['opened'] == '1' ? true : false
			item.save

			item_names = {"ko" => item_data['ko'], "en" => item_data['en'], "cn" => item_data['cn'], "ja" => item_data['ja']}
			item_names.each do |c, n|
				item_name = ItemName.new
				item_name.item = item
				item_name.locale = c
				item_name.name = n
				item_name.save
			end

			# create option
			option_counter = 1
			while !item_data[option_prefix + option_counter.to_s].nil?
				option_data = item_data[option_prefix + option_counter.to_s]
				o = Option.new

				o.item = item
				o.title = option_data['title']
				o.option_type = option_data['type']

				if option_data['type'] == '1'
					# type 1
					o.save
					# create option_item
					oi_counter = 1
					while !option_data[option_item_prefix + oi_counter.to_s].nil?
						oi_data = option_data[option_item_prefix + oi_counter.to_s]
						oi = OptionItem.new

						oi.option = o
						oi.name = oi_data['name']
						oi.price_change = oi_data['price_change']
						oi.quantity = oi_data['quantity']
						oi.limited = oi_data['limited'] == '1' ? true : false
						oi.save

						oi_counter += 1
					end
				else
					# type 2
				  o.max_length = option_data['max_length']
				  o.english_only = option_data['english_only']
				  o.save
				end

				option_counter += 1
			end

			item_counter += 1
		end

		redirect_to :action => :index
	end


	################# index ##################
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
				column('Name') { |item| item.display_name }
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