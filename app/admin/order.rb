ActiveAdmin.register Order do

  scope :all, default: true
  scope :purchase_paid
  scope :purchase_pending
  scope :user_kr
  scope :user_not_kr

  ################ edit #######################
  permit_params :quantity, :order_periodic
  form :partial => "edit"

  ################ edit #######################
  collection_action :edit_options, :method => :patch do
    ooi = OrderOptionItem.find(params[:options]['id'])
    if params[:options]['type'] == "text"
      ooi.option_text = params[:options]['details']
    else
      ooi.option_item_id = params[:options]['details']
    end
    ooi.save
    redirect_to params[:options]['target']
  end

  ################ collection actions #######################
  collection_action :change_status_to_done do
    order = Order.find(params[:id])
    order.purchase.status = PURCHASE_DONE
    order.purchase.save

    redirect_to :action => :index
  end
  collection_action :cancel do
    order = Order.find(params[:id])
    order.purchase.status = PURCHASE_DONE
    order.purchase.save

    redirect_to :action => :index
  end
  
  ########### download inv #############
  collection_action :download_inv do
    csv_builder = ActiveAdmin::CSVBuilder.new

    # set columns
    csv_builder.column("Connector") { |o| o.purchase.reference_number } 
    csv_builder.column("INVCurrency") { |o| "USD" }
    csv_builder.column("INVDeclaration") { |o| "invoice" }
    csv_builder.column("INVReasonforExport") { |o| "Sample" }
    csv_builder.column("INVDescriptionofGoods") { |o| o.item.display_name }
    csv_builder.column("INVHsCode") { |o| "" }
    csv_builder.column("INVOriginCountry") { |o| "KR" }
    csv_builder.column("INVQuantity") { |o| o.quantity }
    csv_builder.column("INVUnitofMeasure") { |o| "EA" }
    csv_builder.column("INVUnitPrice") { |o| o.item.sale_price }
    csv_builder.column("INVAddComment") { |o| "" }
    csv_builder.column("INVFreightCost") { |o| "" }
    csv_builder.column("INVDiscountCost") { |o| "" }
    

    columns = csv_builder.columns

    # Collect the data in an Array to be transposed.
    data = []
    data << columns.map(&:name)
    collection.each do |resource|
      data << columns.map do |column|
        call_method_or_proc_on resource, column.data
      end
    end

    csv_output = CSV.generate() do |csv|
      data.each do |row|
        csv << row
      end
    end

    # render plain: csv_output.inspect

    send_data csv_output, :filename => "Shipinfo_INV.csv"
  end

  ################ member_action #######################



  ################## sidebar ##########################
  sidebar :help, :only => :index do
    button do
      link_to "Download INV", { :action => :download_inv }, {:style => "color:white;text-decoration:none"}
    end
  end



  ################ view #######################

  filter :id, :label => "Order No."
  filter :item, :as => :select
  filter :purchase_status, :as => :select, :collection => Purchase::STATUSES.invert, :label_method => :status_name
  filter :quantity
  filter :order_periodic
  filter :created_at
  filter :updated_at
  filter :deleted
  filter :purchase_user_country, :as => :select, :collection => proc { User.uniq.pluck(:country) }, :label => "country"
  filter :purchase_user_country_eq, :as => :string
  filter :purchase_user_email, :as => :string, :label => "email"

  ################ index #######################
  index do
    column :id do |o|
      link_to o.id, admin_order_path(o)
    end
    column "status" do |o|
      status_string = Purchase::STATUSES.invert.keys
      status_css = ['', 'warning', 'error', 'yes', 'complete']
      status_tag( status_string[o.purchase.status], status_css[o.purchase.status] )
    end
    column "Product" do |o|
      o.item.display_name
    end
    column :order_periodic
    column :quantity
    column "total_weight" do |o|
      o.item.weight * o.quantity
    end
    column "country" do |o|
      o.purchase.user.country
    end
    column "user_id" do |o|
      o.purchase.user_id
    end
    column "recipient" do |o|
      o.purchase.recipient
    end
    column "city" do |o|
      o.purchase.city
    end
    column "address" do |o|
      o.purchase.address
    end
    column "postcode" do |o|
      o.purchase.postcode
    end
    column "phonenumber" do |o|
      o.purchase.phonenumber
    end
    column "email" do |o|
      o.purchase.user.email
    end
    column "결제금액" do |o|
      o.purchase.amt
    end
    column "결제시간" do |o|
      o.purchase.approval_ymdhms
    end
    column :updated_at
    column :created_at
    column "Show" do |o|
      link_to "Show", { :action => :show, :id => o.id }, {:style => "border-radius: 4px;font-size: 14px;font-weight: bold;line-height: 200%;text-decoration: none !important;background: white;background: -webkit-linear-gradient(-90deg, white, #e7e7e7);background: -moz-linear-gradient(-90deg, white, #e7e7e7);background: linear, 180deg, white, #e7e7e7;box-shadow: 0 1px 1px rgba(0, 0, 0, 0.1), 0 1px 0 0 rgba(255, 255, 255, 0.8) inset;border: solid 1px #c7c7c7;border-color: #c7c7c7;padding: 3px 5px;color: #5e6469 !important;"}
    end
    column "Cancel" do |o|
      link_to "return", { :action => :cancel, :id => o.id }, {:style => "border-radius: 4px;font-size: 14px;letter-spacing: 0.5px;line-height: 200%;text-decoration: none !important;background: #d45f53;background: -webkit-linear-gradient(-90deg, #d45f53, #d05a49);background: -moz-linear-gradient(-90deg, #d45f53, #d05a49);background: linear, 180deg, #d45f53, #d05a49;border: solid 1px #b43f33;border-color: #b43f33;padding: 3px 5px;color: #ffffff !important;"}
    end
  end

  ################ show #######################
  show do
    columns do
      column do
        attributes_table do
          row :id do |o|
            link_to o.id, admin_order_path(o)
          end
          row "status" do |o|
            status_string = Purchase::STATUSES.invert.keys
            status_css = ['', 'warning', 'warning', 'yes',   'complete']
            status_tag( status_string[o.purchase.status], status_css[o.purchase.status] )
          end
          row "Product" do |o|
            o.item.display_name
          end
          row :order_periodic
          row :quantity
          row "total_weight" do |o|
            o.item.weight * o.quantity
          end
          row "country" do |o|
            o.purchase.user.country
          end
          row "user_id" do |o|
            o.purchase.user_id
          end
          row "recipient" do |o|
            o.purchase.recipient
          end
          row "city" do |o|
            o.purchase.city
          end
          row "address" do |o|
            o.purchase.address
          end
          row "postcode" do |o|
            o.purchase.postcode
          end
          row "phonenumber" do |o|
            o.purchase.phonenumber
          end
          row "email" do |o|
            o.purchase.user.email
          end
          row "결제금액" do |o|
            o.purchase.amt
          end
          row :updated_at
          row :created_at
          row "Edit" do |o|
            link_to "Edit", { :action => :edit, :id => o.id }, {:style => "border-radius: 4px;font-size: 14px;font-weight: bold;line-height: 200%;text-decoration: none !important;background: white;background: -webkit-linear-gradient(-90deg, white, #e7e7e7);background: -moz-linear-gradient(-90deg, white, #e7e7e7);background: linear, 180deg, white, #e7e7e7;box-shadow: 0 1px 1px rgba(0, 0, 0, 0.1), 0 1px 0 0 rgba(255, 255, 255, 0.8) inset;border: solid 1px #c7c7c7;border-color: #c7c7c7;padding: 3px 5px;color: #5e6469 !important;"}
          end
          row "Cancel" do |o|
            link_to "return", { :action => :cancel, :id => o.id }, {:style => "border-radius: 4px;font-size: 14px;letter-spacing: 0.5px;line-height: 200%;text-decoration: none !important;background: #d45f53;background: -webkit-linear-gradient(-90deg, #d45f53, #d05a49);background: -moz-linear-gradient(-90deg, #d45f53, #d05a49);background: linear, 180deg, #d45f53, #d05a49;border: solid 1px #b43f33;border-color: #b43f33;padding: 3px 5px;color: #ffffff !important;"}
          end
        end
      end
      column do
        panel "Order Details" do
          table_for Order.find(params[:id]).order_option_items do |ooi|
            column("Option_Title") { |ooi| ooi.option.title } 
            column("Option_Details") do |ooi|
              if ooi.option_item_id == -1
                render :partial => "edit_options", :locals => { :target => "/admin/orders/#{params[:id]}", :id => ooi.id, :type => "text", :data => ooi.option_text }
              else
                col = ooi.option.option_items.pluck(:name, :id)
                render :partial => "edit_options", :locals => { :target => "/admin/orders/#{params[:id]}", :id => ooi.id, :type => "select", :data => ooi.option_item.id, :collection => col }
              end
            end
          end
        end
      end
    end
  end


  ################ csv #######################
  csv do
    column :id
    column "status" do |o|
      status_string = Purchase::STATUSES.invert.keys
      status_string[o.purchase.status]
    end
    column "Product" do |p|
      p.item.display_name
    end
    column :order_periodic
    column :quantity
    column "total_weight" do |o|
      o.item.weight * o.quantity
    end
    column "country" do |o|
      o.purchase.user.country
    end
    column "user_id" do |o|
      o.purchase.user_id
    end
    column "recipient" do |o|
      o.purchase.recipient
    end
    column "city" do |o|
      o.purchase.city
    end
    column "address" do |o|
      o.purchase.address
    end
    column "postcode" do |o|
      o.purchase.postcode
    end
    column "phonenumber" do |o|
      o.purchase.phonenumber
    end
    column "email" do |o|
      o.purchase.user.email
    end
    column "결제금액" do |o|
      o.purchase.amt
    end
    column :updated_at
    column :created_at
  end

end
