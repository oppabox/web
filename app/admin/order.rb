ActiveAdmin.register Order do
  menu :priority => 3
  config.sort_order = 'purchases.reference_number_desc'
  # purchase_status_css = ['', 'warning', 'error', 'yes', 'complete']
  purchase_status_css = ['', 'complete', '', 'error']
  order_status_css = ['', '', 'warning', 'yes', 'complete', 'error', '']


  # Convert to Euc-kr
  require 'iconv'

  scope proc{ "전체" }, :except_ordering
  scope proc{ I18n.t("purchase_paid") }, :paid, default: true
  scope proc{ I18n.t("STATUS_ORDER_PREPARING_ORDER") }, :prepare_order
  scope proc{ I18n.t("STATUS_ORDER_PREPARING_DELIVERY") }, :prepare_delivery
  scope proc{ I18n.t("STATUS_ORDER_ON_DELIVERY") }, :on_delivery
  scope proc{ I18n.t("STATUS_ORDER_DONE") }, :done
  scope proc{ I18n.t("STATUS_ORDER_CANCEL") }, :cancelled
  scope proc{ I18n.t("purchase_pending") }, :pending
  scope proc{ I18n.t("purchase_cancel") }, :purchase_cancelled
  

  scope_to :current_admin_user

  controller do
    def scoped_collection
      super.includes(:purchase)
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
  collection_action :transition do
    order = Order.find(params[:id])
    target_status = params[:target]
    order.status = target_status
    order.save

    flash[:notice] = "#{order.purchase.reference_number} status is changed to #{Order::STATUSES[order.status]}."
    redirect_to :action => :index
  end
  collection_action :cancel do
    order = Order.find(params[:id])
    order.status = Order::STATUS_CANCEL
    order.cancel_transaction
    order.save

    flash[:alert] = "#{order.purchase.reference_number} is cancelled."
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
    span do
      link_to "Download INV", download_inv_admin_orders_path(params.slice(:q, :scope)), { :class => "btn btn-default" }
    end
    span do
      link_to "YAMOOJIN", yamoojin_csv_admin_orders_path(params.slice(:q, :scope)), { :class => "btn btn-default" }
    end
  end



  ################ view #######################

  filter :id
  filter :purchase_reference_number, :as => :string_range, :label => "주문번호"
  filter :purchase_reference_number_contains, :as => :string, :label => "주문번호"
  filter :status, :as => :select, :collection => Order::STATUSES.invert, :label_method => :status_name, :label => "주문상태"
  filter :purchase_approval_datetime, :as => :date_range, :label => "결제시간"
  filter :purchase_recipient_contains, :as => :string, :label => "수취인"
  filter :item, :as => :select, :label => "상품"
  filter :item_box_id, :as => :select, :collection => proc { current_admin_user.boxes.pluck(:display_name, :id) }, :label => "박스"
  filter :order_periodic, :label => "정기구매"
  filter :purchase_user_country_eq, :as => :string, :label => "국가"
  filter :purchase_user_country_not_eq, :as => :string, :label => "제외한 모든 국가"
  filter :purchase_user_email_contains, :as => :string, :label => "Email"

  ################ index #######################
  index do
    column :id do |o|
      link_to o.id, admin_order_path(o)
    end
    column "주문번호", :reference, sortable: 'purchases.reference_number' do |o|
      para o.purchase.reference_number
    end
    column "결제상태" do |o|
      status_string = Purchase::STATUSES.invert.keys
      para status_tag( t(status_string[o.purchase.status]), purchase_status_css[o.purchase.status] )
    end
    column "주문상태" do |o|
      status_string = Order::STATUSES.invert.keys  
      para status_tag( t(status_string[o.status]), order_status_css[o.status] )
    end
    column "상품명" do |o|
      para o.item.display_name
    end
    column "정기구매", :order_periodic
    column "수량 (무게)" do |o|
      para o.quantity.to_s + ' (' + (o.item.weight * o.quantity).to_s + ')'
    end
    column "구매자 정보" do |o|
      para o.purchase.user.name + ' (' + o.purchase.user.country + ')'
      para o.purchase.user.email
    end
    column "수취인" do |o|
      o.purchase.recipient
    end
    column "주소 / 도시 / 우편번호" do |o|
      para o.purchase.address
      para o.purchase.city
      para o.purchase.postcode
    end
    column "전화번호" do |o|
      para o.purchase.phonenumber
    end
    column "결제수단" do |o|
      Purchase::PAY_OPTIONS.invert[o.purchase.pay_option]
    end
    column "결제금액" do |o|
      o.purchase.amt
    end
    column "결제시간", sortable: 'purchases.approval_datetime' do |o|
      dt = o.purchase.approval_datetime.nil? ? DateTime.strptime('20000101', '%Y%m%d') : o.purchase.approval_datetime
      span dt.strftime('%F')
      span dt.strftime('%T')
    end
    column "" do |o|
      para link_to "상세", { :action => :show, :id => o.id }, { :class => "btn btn-default margin_p" }
      
      case o.status
        when Order::STATUS_PREPARING_ORDER
          target = Order::STATUS_PREPARING_DELIVERY
        when Order::STATUS_PREPARING_DELIVERY
          target = Order::STATUS_ON_DELIVERY
        when Order::STATUS_ON_DELIVERY
          target = Order::STATUS_DONE
        else # ordering, deleted, done, canceled
          target = ''
      end
      unless target == ''
        para link_to "진행", { :action => :transition, :id => o.id, :target => target }, { :class => "btn btn-primary margin_p" }
      end
      
      unless o.status == Order::STATUS_CANCEL
        para link_to "취소", { :action => :cancel, :id => o.id }, { :class => "btn btn-danger margin_p" }
      end
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
            status_tag( status_string[o.purchase.status], purchase_status_css[o.purchase.status] )
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
            link_to "Edit", { :action => :edit, :id => o.id }, { :class => "btn btn-default" }
          end
          row "Cancel" do |o|
            link_to "return", { :action => :cancel, :id => o.id }, { :class => "btn btn-danger" }
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
