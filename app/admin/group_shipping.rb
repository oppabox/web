ActiveAdmin.register GroupShipping do
	menu label: "묶음 배송", :priority => 7
	config.clear_sidebar_sections!
	permit_params :name
	scope_to :current_admin_user
	form :partial => "edit"

	################# update #################
	collection_action :create, :method => :post do
		g = GroupShipping.new
		i_ids = params[:group_shipping]['items'].keep_if { |v| v != "" }
		g.name = params[:group_shipping]['name']
		g.items = current_admin_user.items.where(id: i_ids)
		g.admin_user = current_admin_user
		
		if g.save
			flash[:notice] = "Group Shipping #{g.name} is created successfully!"
			redirect_to :action => :edit, :id => g.id
		else
			flash[:error] = box.errors.full_messages
			redirect_to :back
		end
	end	

	################# update #################
	collection_action :update, :method => :patch do
		g = current_admin_user.group_shippings.find(params[:id])
		i_ids = params[:group_shipping]['items'].keep_if { |v| v != "" }
		g.name = params[:group_shipping]['name']
		g.items = current_admin_user.items.where(id: i_ids)
		
		if g.save
			flash[:notice] = "Group Shipping #{g.name} is updated successfully!"
			redirect_to '/admin/group_shippings/'
		else
			flash[:error] = box.errors.full_messages
			redirect_to :back
		end
	end


	################# index #################
	index :title => '묶음 배송 관리' do
		column "그룹명", :name
		column "생성일", :created_at
		column "아이템" do |g|
			unless g.items.count == 0
				ul do
					g.items.each do |i|
						li i.display_name
					end
				end
			end
		end
		column "" do |g|
			para link_to "수정", edit_admin_group_shipping_path(g.id), { :class => "btn btn-default" }
		end
	end
end
