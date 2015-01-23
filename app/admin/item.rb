ActiveAdmin.register Item do
	menu :priority => 6

	form :partial => "edit"

	collection_action :update, :method => :patch do
		data = params[:item]
		item = Item.find(params[:id])

		item.original_price = data['original_price']
		item.sale_price = data['sale_price']
		item.weight	= data['weight']
		item.buy_limit = data['buy_limit']
		item.periodic = data['periodic'] == '1' ? true : false
		item.opened = data['opened'] == '1' ? true : false

		if data['limited'] == '1' ? true : false
			item.limited = true
			item.quantity = data['quantity']
		else
			item.limited = false
		end

		['ko', 'en', 'cn', 'ja'].each do |locale|
			item_name = item.item_names.where(:locale => locale).first
			item_name.name = data['name'][locale]
			item_name.save
		end

		if item.save
			flash[:notice] = "#{item.display_name} is successfully updated!"
			redirect_to :action => :edit, :id => params[:id]
		else
			flash[:error] = "#{item.display_name} cannot be updated. It contains invalid inputs!"
			redirect_to :back
		end
	end

	collection_action :update_options, :method => :patch do
		respond_to do |format|

			ActiveRecord::Base.transaction do 
				begin
					item = Item.find(params[:item_id])

					option_prefix = "option_"
					option_item_prefix = "option_item_"

					options_data = params[:options]
					options = item.options

					option_cnt = 0
					while !options_data[option_prefix + option_cnt.to_s].nil?
						option_data = options_data[option_prefix + option_cnt.to_s]
						option = options.find(option_data['id'])

						if option.option_type == OPTION_TYPE_STRING
							option.title = option_data['title']
							option.max_length = option_data['max_length']
							option.english_only = option_data['english_only'] == '1' ? true : false
							option.save!
						else # OPTION_TYPE_NORMAL
							option.title = option_data['title']
							option.save!


							option_items = option.option_items
							option_item_cnt = 0
							while !option_data[option_item_prefix + option_item_cnt.to_s].nil?
								puts option_data[option_item_prefix + option_item_cnt.to_s]
								option_item_data = option_data[option_item_prefix + option_item_cnt.to_s]
								option_item = option_items.find(option_item_data['id'])

								option_item.name = option_item_data['name']
								option_item.quantity = option_item_data['quantity']
								option_item.limited	= option_item_data['limited'] == '1' ? true : false
								option_item.save!

								option_item_cnt += 1
							end
						end

						option_cnt += 1
					end

					format.html { render html: "Options are successfully updated!" }
				rescue ActiveRecord::RecordNotFound, ActiveRecord::RecordInvalid, ActiveRecord::RecordNotSaved => e
					format.html { render html: e.message, :status => "403" }
				end
			end

		end
	end

	index do
		column :id
		column "Image" do |i|
			tag :img, :src => "/images/box/#{i.path}.jpg", :width => "100px", :height => "100px"
		end
		column :box
		column "Name" do |i|
			i.display_name
		end
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