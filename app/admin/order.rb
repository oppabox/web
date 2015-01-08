ActiveAdmin.register Order do

  scope :all, default: true
  scope :purchase_paid
  scope :purchase_pending
  scope :user_kr
  scope :user_not_kr


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
  ########### download bl #############
  collection_action :download_bl do
    csv_builder = ActiveAdmin::CSVBuilder.new

    # set columns
    csv_builder.column("ReceiverCompanyName") { |o| o.purchase.recipient }
    csv_builder.column("ReceiverContactName") { |o| o.purchase.recipient }
    csv_builder.column("ReceiverAddress1") do |o|
      address_array = o.purchase.address.split(" ")
      address_split = Array.new(3){""}

      address_array.each do |x|
        0.upto(address_split.size - 1) do |y|
          next if (address_split[y] + x).size > 35 #UPS can have address with legnth 35.
          address_split[y] += " " if address_split[y].size > 1
          address_split[y] += x
          break
        end
      end

      address_split[0]
    end
    csv_builder.column("ReceiverAddress2") do |o|
      address_array = o.purchase.address.split(" ")
      address_split = Array.new(3){""}

      address_array.each do |x|
        0.upto(address_split.size - 1) do |y|
          next if (address_split[y] + x).size > 35 #UPS can have address with legnth 35.
          address_split[y] += " " if address_split[y].size > 1
          address_split[y] += x
          break
        end
      end

      address_split[1]
    end
    csv_builder.column("ReceiverAddress3") do |o|
      address_array = o.purchase.address.split(" ")
      address_split = Array.new(3){""}

      address_array.each do |x|
        0.upto(address_split.size - 1) do |y|
          next if (address_split[y] + x).size > 35 #UPS can have address with legnth 35.
          address_split[y] += " " if address_split[y].size > 1
          address_split[y] += x
          break
        end
      end

      address_split[2]
    end
    csv_builder.column("ReceiverCity") { |o| o.purchase.city }
    csv_builder.column("ReceiverState") { |o| o.purchase.state }
    csv_builder.column("ReceiverPostal") { |o| o.purchase.postcode }
    csv_builder.column("ReceiverCountry") { |o| o.purchase.user.country }
    csv_builder.column("ReceiverPhoneNumber") { |o| o.purchase.phonenumber }
    csv_builder.column("ReceiverEmail") { |o| o.purchase.user.email }
    csv_builder.column("DescriptionofShipment") { |o| o.item.display_name }
    csv_builder.column("YOption") { |o| "Y" }
    csv_builder.column("NOption") { |o| "N" }
    csv_builder.column("ServiceType") { |o| "Express Saver" }
    csv_builder.column("ActWeight") { |o| o.item.weight * o.quantity }
    csv_builder.column("NumofPackage") { |o| "1" }
    csv_builder.column("PackageType") { |o| "Package" }
    csv_builder.column("ShippingChargeto") { |o| "Shipper" }
    csv_builder.column("ShippingTaxto") { |o| "Receiver" }
    csv_builder.column("ReferenceNumber1") { |o| "refnum" } 
    csv_builder.column("ReferenceNumber2") { |o| "" }
    csv_builder.column("ReferenceNumber3") { |o| "" }
    csv_builder.column("ReferenceNumber4") { |o| "" }
    csv_builder.column("ReferenceNumber5") { |o| "Saver" }


    columns = csv_builder.columns

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

    send_data csv_output, :filename => "Shipinfo_BL.csv"
  end
  ########### download inv #############
  collection_action :download_inv do
    csv_builder = ActiveAdmin::CSVBuilder.new

    # set columns
    csv_builder.column("ReferenceNumber1") { |o| "refnum" } 
    csv_builder.column("INVCurrency") { |o| "USD" }
    csv_builder.column("INVDeclaration") { |o| "invoice" }
    csv_builder.column("INVReasonforExport") { |o| "Sale" }
    csv_builder.column("INVDescriptionofGoods") { |o| o.item.display_name }
    csv_builder.column("INVHsCode") { |o| "" }
    csv_builder.column("INVOriginCountry") { |o| "KR" }
    csv_builder.column("INVQuantity") { |o| "" }
    csv_builder.column("INVUnitofMeasure") { |o| "EA" }
    csv_builder.column("INVUnitPrice") { |o| "" }
    csv_builder.column("INVAddComment") { |o| "" }
    csv_builder.column("INVFleightCost") { |o| "" }
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

  index do
    column :id do |o|
      link_to o.id, admin_order_path(o)
    end
    column "status" do |o|
      status_string = Purchase::STATUSES.invert.keys
      status_css = ['', 'warning', 'error', 'complete']
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
    column "Done" do |o|
      link_to "done", { :action => :change_status_to_done, :id => o.id }, {:style => "border-radius: 4px;font-size: 14px;font-weight: bold;line-height: 200%;text-decoration: none !important;background: white;background: -webkit-linear-gradient(-90deg, white, #e7e7e7);background: -moz-linear-gradient(-90deg, white, #e7e7e7);background: linear, 180deg, white, #e7e7e7;box-shadow: 0 1px 1px rgba(0, 0, 0, 0.1), 0 1px 0 0 rgba(255, 255, 255, 0.8) inset;border: solid 1px #c7c7c7;border-color: #c7c7c7;padding: 3px 5px;color: #5e6469 !important;"}
    end
    column "Cancel" do |o|
      link_to "return", { :action => :cancel, :id => o.id }, {:style => "border-radius: 4px;font-size: 14px;letter-spacing: 0.5px;line-height: 200%;text-decoration: none !important;background: #d45f53;background: -webkit-linear-gradient(-90deg, #d45f53, #d05a49);background: -moz-linear-gradient(-90deg, #d45f53, #d05a49);background: linear, 180deg, #d45f53, #d05a49;border: solid 1px #b43f33;border-color: #b43f33;padding: 3px 5px;color: #ffffff !important;"}
    end
  end

  sidebar :help, :only => :index do
    button do
      link_to "Download BL", { :action => :download_bl }, {:style => "color:white;text-decoration:none"}
    end
    button do
      link_to "Download INV", { :action => :download_inv }, {:style => "color:white;text-decoration:none"}
    end
  end

  show do
    columns do
      column do
        attributes_table do
          row :id do |o|
            link_to o.id, admin_order_path(o)
          end
          row "status" do |o|
            status_string = Purchase::STATUSES.invert.keys
            status_css = ['', 'warning', 'warning', 'complete']
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
          row "Done" do |o|
            link_to "done", { :action => :change_status_to_done, :id => o.id }, {:style => "border-radius: 4px;font-size: 14px;font-weight: bold;line-height: 200%;text-decoration: none !important;background: white;background: -webkit-linear-gradient(-90deg, white, #e7e7e7);background: -moz-linear-gradient(-90deg, white, #e7e7e7);background: linear, 180deg, white, #e7e7e7;box-shadow: 0 1px 1px rgba(0, 0, 0, 0.1), 0 1px 0 0 rgba(255, 255, 255, 0.8) inset;border: solid 1px #c7c7c7;border-color: #c7c7c7;padding: 3px 5px;color: #5e6469 !important;"}
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
            column("Option_Details") { |ooi| ooi.option_item.name }
          end
        end
      end
    end
  end


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

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # permit_params :list, :of, :attributes, :on, :model
  #
  # or
  #
  # permit_params do
  #   permitted = [:permitted, :attributes]
  #   permitted << :other if resource.something?
  #   permitted
  # end


end
