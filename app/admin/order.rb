ActiveAdmin.register Order do
  config.sort_order = 'purchases.reference_number'
  # Convert to Euc-kr
  require 'iconv'

  scope :except_ordering, default: true
  scope :purchase_paid
  scope :purchase_pending
  scope :user_kr
  scope :user_not_kr

  controller do
    def scoped_collection
      resource_class.includes(:purchase)
    end

    # CSV 출력시에만 "-" 입력
    def fix_kr_phonenumber country, number
      if !number.nil? && country == "KR" 
        if (number.gsub "-", "").size == 10
          number.gsub("-","").insert(3, '-').insert(7, '-')
        elsif number.size == 11
          number.insert(3, '-').insert(8, '-')
        end
      end
      return number
    end
  end

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

    # render plain: csv_output

    send_data csv_output, :type => 'text/csv; charset=iso-8859-1; header=present', :filename => DateTime.current().strftime("%Y%m%d")+" - UPS_Shipinfo_INV.csv"
  end

  ########### download YAMOOJIN #############
  collection_action :yamoojin_csv do
    csv_builder = ActiveAdmin::CSVBuilder.new

    # set columns
    csv_builder.column("수취고객명") { |o| o.purchase.recipient }
    csv_builder.column("수취인") { |o| ""}
    csv_builder.column("수취인 전화") { |o| "" }
    csv_builder.column("수취인 휴대폰") { |o| fix_kr_phonenumber(o.purchase.user.country, o.purchase.phonenumber) }
    csv_builder.column("우편번호") { |o| o.purchase.postcode }
    csv_builder.column("수취인 주소") { |o| o.purchase.address }
    csv_builder.column("총중량") { |o| o.item.weight * o.quantity }
    csv_builder.column("상품명1") { |o| o.item.display_name }
    csv_builder.column("수량1") { |o| o.quantity }
    csv_builder.column("물품가격") { |o| o.item.sale_price * o.quantity }
    csv_builder.column("메모") { |o| "" }
    csv_builder.column("출력매수") { |o| "" }
    

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

    # Iconv set
    conv = Iconv.new("EUC-KR//IGNORE","UTF-8")
    csv_output = conv.iconv(csv_output)

    
    # send_data csv_output, :type => 'text/csv; charset=iso-8859-1; header=present', :filename => DateTime.current().strftime("%Y%m%d") + " - Yamoojin.csv"
    # send_data Iconv.conv('iso-8859-1//IGNORE', 'euc-kr', csv_output), :type => 'text/csv; charset=iso-8859-1; header=present', :filename => DateTime.current().strftime("%Y%m%d") + " - Yamoojin.csv"

    send_data  csv_output, :filename => DateTime.current().strftime("%Y%m%d") + " - Yamoojin (oppabox).csv"
  end

  ################ member_action #######################



  ################## sidebar ##########################
  sidebar :help, :only => :index do
    button do
      link_to "Download INV", download_inv_admin_orders_path(params.slice(:q, :scope)), { :class => "btn-normal" }
    end
    button do
      link_to "YAMOOJIN.csv", yamoojin_csv_admin_orders_path(params.slice(:q, :scope)), { :class => "btn-normal" }
    end
  end



  ################ view #######################

  filter :id, :label => "Order No."
  filter :purchase_user_id, :as => :string, :label => "User No."
  filter :purchase_recipient, :as => :string, :label => "Recipient Name"
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
    column :reference, sortable: 'purchases.reference_number' do |o|
      o.purchase.reference_number
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
    column "결제수단" do |o|
      PAY_OPTIONS.invert[o.purchase.pay_option]
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
      link_to "Show", { :action => :show, :id => o.id }, { :class => "btn-normal" }
    end
    column "Cancel" do |o|
      link_to "return", { :action => :cancel, :id => o.id }, { :class => "btn-danger" }
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
            status_css = ['', 'warning', 'error', 'yes', 'complete']
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
            link_to "Edit", { :action => :edit, :id => o.id }, { :class => "btn-normal" }
          end
          row "Cancel" do |o|
            link_to "return", { :action => :cancel, :id => o.id }, { :class => "btn-danger" }
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
