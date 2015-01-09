ActiveAdmin.register Purchase do

  scope :all, default: true
  scope :purchase_paid
  scope :purchase_pending
  scope :user_kr
  scope :user_not_kr


  ################## batch action ##########################  
  batch_action :destroy, false
  Purchase::STATUSES.each_with_index do |s|
    batch_action s[1] do |selection|
      Purchase.find(selection).each do |p|
        p.status = s[0]
        p.save
      end

      redirect_to :action => :index
    end
  end


  ########### download bl #############
  collection_action :download_bl do
    csv_builder = ActiveAdmin::CSVBuilder.new

    # set columns
    csv_builder.column("ReceiverCompanyName") { |p| p.recipient }
    csv_builder.column("ReceiverContactName") { |p| p.recipient }
    csv_builder.column("ReceiverAddress1") do |p|
      addr = p.address.nil? ? "" : p.address
      address_array = addr.split(" ")
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
    csv_builder.column("ReceiverAddress2") do |p|
      addr = p.address.nil? ? "" : p.address
      address_array = addr.split(" ")
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
    csv_builder.column("ReceiverAddress3") do |p|
      addr = p.address.nil? ? "" : p.address
      address_array = addr.split(" ")
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
    csv_builder.column("ReceiverCity") { |p| p.city }
    csv_builder.column("ReceiverState") { |p| p.state }
    csv_builder.column("ReceiverPostal") { |p| p.postcode }
    csv_builder.column("ReceiverCountry") { |p| p.user.country }
    csv_builder.column("ReceiverPhoneNumber") { |p| p.phonenumber }
    csv_builder.column("ReceiverEmail") { |p| p.user.email }
    csv_builder.column("DescriptionofShipment") { |p| "Woman long sleeve" }
    csv_builder.column("YOption") { |p| "Y" }
    csv_builder.column("NOption") { |p| "N" }
    csv_builder.column("ServiceType") { |p| "Express Saver" }
    csv_builder.column("ActWeight") do |p|
      sum = 0
      p.orders.each do |o|
        sum += (o.item.weight * o.quantity)
      end
      sum
    end
    csv_builder.column("NumofPackage") do |p|
      sum = 0
      p.orders.each do |o|
        sum += o.quantity
      end
      sum
    end
    csv_builder.column("PackageType") { |p| "Package" }
    csv_builder.column("ShippingChargeto") { |p| "Shipper" }
    csv_builder.column("ShippingTaxto") { |p| "Receiver" }
    csv_builder.column("ReferenceNumber1") { |p| p.reference_number } 
    csv_builder.column("ReferenceNumber2") { |p| "" }
    csv_builder.column("ReferenceNumber3") { |p| "" }
    csv_builder.column("ReferenceNumber4") { |p| "" }
    csv_builder.column("ReferenceNumber5") { |p| "Saver" }


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

  ################## sidebar ##########################
  sidebar :help, :only => :index do
    button do
      link_to "Download BL", { :action => :download_bl }, {:style => "color:white;text-decoration:none"}
    end
  end

  ################## view ##########################
  index do 
    selectable_column
    column :id do |p|
      link_to p.id, admin_purchase_path(p)
    end
    column "status" do |p|
      status_string = Purchase::STATUSES.invert.keys
      status_css = ['', 'warning', 'error', 'yes', 'complete']
      status_tag( status_string[p.status], status_css[p.status] )
    end
    column "orders" do |p|
      p.orders.map{|o| o.item.display_name}.join("/")
    end
    column "weight" do |p|
      p.orders.map{|o| o.item.weight}.join("/")
    end
    column "country" do |p|
      p.user.country
    end
    column :recipient
    column :city
    column :address
    column :postcode
    column :phonenumber
    column "결제금액", :amt
    column :replycd
    column :replymsg
    column :order_no
    column :pay_type
    column :approval_ymdhms
    column :seq_no
    column :reference_number
  end

  show do
    columns do

      column do
        attributes_table do
          row :id
          row "status" do |p|
            status_string = Purchase::STATUSES.invert.keys
            status_css = ['', 'warning', 'error', 'yes', 'complete']
            status_tag( status_string[p.status], status_css[p.status] )
          end
          row "orders" do |p|
            p.orders.map{|o| o.item.display_name}.join(" / ")
          end
          row "weight" do |p|
            p.orders.map{|o| o.item.weight}.join(" / ")
          end
          row "country" do |p|
            p.user.country
          end
          row :recipient
          row :phonenumber
          # minors
          row :city
          row :address
          row :postcode
          row "결제금액" do |p|
           p.amt
          end
          row :replycd
          row :replymsg
          row :order_no
          row :pay_type
          row :approval_ymdhms
          row :seq_no
          active_admin_comments
        end
      end

      column do
        panel "Order Details" do
          table_for Purchase.find(params[:id]).orders do |o|
            column("id") do |o|
              link_to o.id, admin_order_path(o)
            end
            column("Name") { |o| o.item.display_name }
            column("Quantity") { |o| o.quantity }
            column("Period") { |o| o.order_periodic }
            column("Option_Title") { |o| 
              ul do
                o.order_option_items.each do |ooi|
                  li ooi.option.title
                end
              end
            }
            column("Option_Details") { |o| 
              ul do
                o.order_option_items.each do |ooi|
                  unless ooi.option_item.nil?
                    li ooi.option_item.name
                  end
                end
              end
            }
          end

        end
      end

    end
  end
  
  # sidebar :order, :only => :show do
  #   orders = Purchase.find(params[:id]).orders
  #   h3 "Orders"
  #   div do
  #     ul do
  #       table_for orders do |o|
  #         column "name", :created_at
  #       end
  #     end
  #   end
  # end


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
