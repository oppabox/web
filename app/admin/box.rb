ActiveAdmin.register Box do
	menu :priority => 5
	config.batch_actions = false

	scope proc{''}, :top, default: true, show_count: false

	scope_to :current_admin_user

	controller do
		def scoped_collection
			super.includes(:items => :item_names)
		end
	end

	################# new ##################
	form :partial => "form"

	collection_action :create, :method => :post do
		data = params[:box]
		
		# create box
		box = Box.new
		box.display_name = data['display_name']
		box.path = data['display_name'].gsub(" ", "_").downcase
		box.opened = data['opened'] == '1' ? true : false
		unless data['parent'] == ""
			box.parent = Box.find(data['parent'].to_i)
		end
		box.admin_user = current_admin_user
		
		if box.save
			# image save
			unless data['image'].nil?
				box_io = data['image'][0]
				File.open(box.image_path, 'wb') do |file|
					file.write(box_io.read)
				end
			end

			unless data['top_image'].nil?
				box_io = data['top_image'][0]
				File.open(box.top_image_path, 'wb') do |file|
					file.write(box_io.read)
				end
			end

			flash[:notice] = "Box #{data['display_name']} is created successfully!"
			redirect_to :action => :edit, :id => box.id
		else
			flash[:error] = "Box #{data['display_name']} cannot be created. Invalid inputs exist!"
			redirect_to :back
		end
	end

	collection_action :update, :method => :patch do
		box = Box.find(params[:id])
		data = params[:box]

		old_path = box.path

		box.display_name = data['display_name']
		box.path = data['display_name'].gsub(" ", "_").downcase
		box.opened = data['opened'] == '1' ? true : false
		box.display_order = data['display_order']

		if box.save
			# check whether path is changed
			unless old_path == box.path
				# remane file
				File.rename(Box.top_image_path(old_path), box.top_image_path)
				File.rename(Box.image_path(old_path), box.image_path)
				
				# rename item image's bot path
				if File.directory?(Box.item_path(old_path))
					FileUtils.copy_entry(Box.item_path(old_path),
															 box.item_path,
															 :preserve => true)
					FileUtils.remove_dir(Box.item_path(old_path), true)
				end
			end

			# check whether image is changed
			unless data['image'].nil?
				io = data['image']
				File.open(box.image_path, 'wb') do |file|
					file.write(io.read)
				end
			end

			unless data['top_image'].nil?
				io = data['top_image'][0]
				File.open(box.top_image_path, 'wb') do |file|
					file.write(io.read)
				end
			end

			flash[:notice] = "#{box.display_name} is successfully updated!"
			redirect_to :action => :edit, :id => box.id
		else
			flash[:error] = "#{box.display_name} cannot be updated. Invalid inputs exist!"
			redirect_to :back
		end
	end

	collection_action :destroy, :method => :delete do
		box = Box.find(params[:id])
		box.destroy

		flash[:notice] = "#{box.display_name} is successfully deleted!"
		redirect_to :action => :index
	end

	################# index ##################
	index do
		column :id
		column "제품이미지" do |b|
			tag :img, :src => "/images/box/#{b.path}.jpg", :width => "100px", :height => "100px"
		end
		column "제품명", :display_name
		column "판매중", :opened
		column "등록일", :created_at
		column "" do |b|
			para link_to "상세", { :action => :edit, :id => b.id }, { :class => 'btn btn-default' }
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
			table_for Box.find(params[:id]).items, class: 'table table-bordered detail_table', row_class: ->elem { "" } do |item|
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
				column('') do |item| 
					para link_to "수정", edit_admin_item_path(item.id , :target => "/#{params[:controller]}/#{params[:id]}" ), { :class => 'btn btn-default' }
				end
			end #table_for
		end #panel
	end

end