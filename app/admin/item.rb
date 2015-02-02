ActiveAdmin.register Item do
	menu :priority => 6

	#################### controller ####################
	form :partial => "form"

	controller do
	end

	############### create ###############	
	collection_action :create, :method => :post do
		data = params[:item]
		item = Item.new
		
		# must have box
		begin
			item.box = Box.find(data['box'])
		
			ActiveRecord::Base.transaction do 
				item.path = data['path']
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
					item_name = ItemName.new
					item_name.item = item
					item_name.locale = locale
					item_name.name = data['name'][locale]
					item_name.save!
				end

				if item.save
					# save image
					FileUtils.mkdir_p Rails.root.join('public', 'images', 'items', item.box.path, item.path)
					['ko', 'en', 'cn', 'ja'].each do |locale|
						FileUtils.mkdir_p Rails.root.join('public', 'images', 'items', item.box.path, item.path, locale)
					end
					unless data['image'].nil?
						io = data['image'][0]
						File.open(Rails.root.join('public', 'images', 'items', item.box.path, item.path, item.path + '.jpg'), 'wb') do |file|
							file.write(io.read)
						end
					end

					flash[:notice] = "The item is saved successfully!"
					redirect_to :action => :edit, :id => item.id
				else
					raise ActiveRecord::Rollback
					flash[:error] = "Cannot be saved. It contains invalid inputs!"
					redirect_to :back
				end
			end
		rescue
			flash[:error] = "Cannot be saved. The box is not existed!"
			redirect_to :back
		end

	end

	############### update ###############
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

		shipping_list = []
		data['shippings'].each do |shipping|
			# data is [name, value]
			if shipping[1] == '1'
				shipping_list << shipping[0]
			end
		end

		shippings = Shipping.where(id: shipping_list)
		puts shippings.inspect
		item.shippings = shippings

		if item.save
			unless data['image'].nil?
				io = data['image'][0]
				File.open(Rails.root.join('public', 'images', 'items', item.box.path, item.path, item.path + '.jpg'), 'wb') do |file|
					file.write(io.read)
				end
			end
			flash[:notice] = "#{item.display_name} is successfully updated!"
			redirect_to :action => :edit, :id => params[:id]
		else
			flash[:error] = "#{item.display_name} cannot be updated. It contains invalid inputs!"
			redirect_to :back
		end
	end

	############### update_options ###############
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
								option_item.price_change = option_item_data['price_change']
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

	############### add_option ###############
	collection_action :add_option, :method => :post do
		ActiveRecord::Base.transaction do 
			begin
				data = params[:new_option]
				item = Item.find(data['item_id'])

				option = Option.new
				option.option_type = Option::TYPE.invert[data['type']]
				option.item = item

				if option.option_type == OPTION_TYPE_STRING
					data = data['string']
					option.title = data['name']
					option.max_length = data['max_length'].blank? ? option.max_length : data['max_length']
					option.english_only = data['english_only'] == '1' ? true : false
					option.save!
				else
					option.title = data['name']
					option.save!

					oi_cnt = 0
					while !data["normal_" + oi_cnt.to_s].nil?
						oi_data = data["normal_" + oi_cnt.to_s]
						oi = OptionItem.new
						oi.option = option
			      oi.name = oi_data['option_name']
			      oi.quantity = oi_data['quantity']
			      oi.limited = oi_data['limited'] == '1' ? true : false
			      oi.price_change = oi_data['price_change']
			      oi.save!

			      oi_cnt += 1
					end
				end

				redirect_to :action => :edit, :id => item.id
			rescue ActiveRecord::RecordNotFound, ActiveRecord::RecordInvalid, ActiveRecord::RecordNotSaved => e
				flash[:error] = "Fail to add new option. Invalid inputs exits!"
				redirect_to :back
			end
		end
	end

	############### delete_option ###############
	collection_action :delete_option, :method => :post do
		option = Option.find(params['option_id'])

		if params['oi_id'].nil?
			# just delete option
			option.destroy
		else
			# delete option item
			oi = OptionItem.find(params['oi_id'])
			oi.destroy

			# no option items anymore
			if option.option_items.count == 0
				option.destroy
			end
		end

		redirect_to :action => :edit, :id => params[:id]
	end

	############### load_image ###############
	collection_action :load_image, :method => :post do
		item = Item.find(params[:id])
		images = {}

		['ko', 'en', 'cn', 'ja'].each do |locale|
			images[locale] = []
			index = 1
			Rails.root.join('public', 'images', 'items', item.box.path, item.path, locale)
			begin
	      exists = File.exists?(Rails.root.join("public", "images", "items", item.box.path, item.path, locale.to_s, "#{index}.jpg").to_s)
	      if exists 
	      	images[locale] << item.image_locale_url(locale, index.to_s)
	      end
	      index += 1
	    end while exists 
		end

		render json: images
	end

	############### add_image ###############
	collection_action :add_image, :method => :post do
		data = params[:file]
		item = Item.find(data['id'])

		unless data['image'].nil? and data['image'].empty?
			data['image'].each do |io|

				tmp = io.original_filename.split("_") # ko_1.jpg
				locale = tmp[0] # ko
				file_name = tmp[1] # 1.jpg

				File.open(Rails.root.join('public', 'images', 'items', item.box.path, item.path, locale, file_name), 'wb') do |file|
					file.write(io.read)
				end

			end
		end

		render json: { :msg => "업로드 완료" }
	end


	#################### views ####################
	index do
		column :id
		column "Image" do |i|
			tag :img, :src => "/images/items/#{i.box.path}/#{i.path}/#{i.path}.jpg", :width => "100px", :height => "100px"
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