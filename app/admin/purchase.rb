ActiveAdmin.register Purchase do
  menu label: "주문 관리", :priority => 2
  config.sort_order = "reference_number_desc"
  # remove action items
  config.clear_action_items!
  status_css = ['', 'complete', 'warning', 'error']
  order_status_css = ['', '', 'warning', 'yes', 'complete', 'error', '']

  # Convert to Euc-kr
  require 'iconv'

  scope proc{ "전체" }, :valid, default: true
  scope proc{ I18n.t('purchase_paid') }, :paid
  scope proc{ I18n.t('purchase_pending') }, :pending
  scope proc{ I18n.t('purchase_cancel') }, :cancelled

  scope_to :current_admin_user

  ################# new ###################
  form :partial => "new"
  
  ################## collection action ##########################  
  collection_action :transition do
    p = Purchase.find(params[:id])
    target_status = params[:target]

    if p.status == Purchase::STATUS_PENDING and target_status == Purchase::STATUS_PAID.to_s
      # when status pending, give new reference_number
      # and set it's orders to preparing status
      p.status = target_status
      p.set_reference_number
      p.status_transaction
    else
      p.status = target_status
    end
    p.save

    flash[:notice] = "#{p.reference_number} status is changed to #{Purchase::STATUSES[p.status]}."
    redirect_to :action => :index
  end

  collection_action :cancel do
    p = Purchase.find(params[:id])
    p.status = Purchase::STATUS_CANCEL

    p.orders.valid.each do |order|
      order.status = Order::STATUS_CANCEL
      # cancel all
      order.cancel_transaction order.quantity
      order.save
    end

    p.save
    flash[:alert] = "#{p.reference_number} is cancelled."
    redirect_to :action => :index
  end

  collection_action :create, :method => :post do
    data = params[:purchases]

    # create purchase
    p = Purchase.new
      email = data['user']
      p.user_id = User.where(email: email).pluck(:id).join().to_i
      p.recipient = data['recipient']
      p.city = data['city']
      p.state = data['state']
      p.address = data['address']
      p.postcode = data['postcode']
      p.phonenumber = data['phonenumber']
      p.status = 1
      p.replycd = "0000"
      p.replymsg = "현금결제(무통장)"
      p.amt = data['amt']
      p.pay_type = "현금결제"
      p.approval_datetime = DateTime.current().strftime("%Y-%m-%d %H:%M:%S")
      p.seq_no = "1234567890"
      p.pay_option = 0
      p.set_reference_number
      p.order_no = p.reference_number
      p.user.country = data['country']
    p.save
    puts data['item_id']
    o = Order.new
      o.purchase_id = p.id
      o.item_id = data['item_id']
      o.quantity = data['quantity']
      o.order_periodic = data['order_periodic']
      o.status = 2
    o.save

    ooi = OrderOptionItem.new
      ooi.order_id = o.id
      ooi.option_item_id = data['option_item_id']
      ooi.option_id = data['option_id']
      ooi.option_text = data['option_text']
    ooi.save

    redirect_to :action => :index
  end

  collection_action :change_item_details, :method => :post do
    items = Item.where(box_id:params[:box_id]).map { |i| { 'id' => i.id, 'name' => i.display_name } }
    render :json => items.to_json
  end

  collection_action :check_country_value, :method => :post do
    check = COUNTRIES.sort_by { |x, y| y }.map {|m,n| {'code' => n, 'country_name' => m } }
    render :json => check.to_json
  end

  collection_action :edit_invoice, :method => :patch do
    oids = []
    params[:invoice]["oids"].split(",").each do |v|
      oids << v
    end
    
    current_admin_user.orders.where(id: oids).each do |order|
      order.invoice = params[:invoice]["invoice"]
      order.save
    end

    render nothing: true
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
      # p.orders.valid.each do |o|
      p.filtered_orders(params[:q]).valid.each do |o|
        sum += (o.item.weight * o.quantity)
      end
      sum
    end
    csv_builder.column("NumofPackage") do |p|
      sum = 0
      # p.orders.valid.each do |o|
      p.filtered_orders(params[:q]).valid.each do |o|
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

    send_data csv_output, :type => 'text/csv; charset=iso-8859-1; header=present', :filename => DateTime.current().strftime("%Y%m%d") + " - UPS_Shipinfo_BL.csv"
  end

  ################## download inv #####################
  collection_action :download_inv do

    csv_output = CSV.generate() do |csv|
      csv << ["Connector",
              "INVCurrency",
              "INVDeclaration",
              "INVReasonforExport",
              "INVDescriptionofGoods",
              "INVHsCode",
              "INVOriginCountry",
              "INVQuantity",
              "INVUnitofMeasure",
              "INVUnitPrice",
              "INVAddComment",
              "INVFreightCost",
              "INVDiscountCost"]

      
      collection.each do |resource|
        ### data_in ###
        # og = OrderGroup.grouping(resource.orders.valid.where(item_id: current_admin_user.items.pluck(:id)))
        og = OrderGroup.grouping(resource.filtered_orders(params[:q]).valid.where(item_id: current_admin_user.items.pluck(:id)))
        og.each_with_index do |order_group, index|
          order_group.orders.each_with_index do |order, sub_idx|
            row = []
            row << order.purchase.reference_number
            row << "USD"
            row << "invoice"
            row << "Sample"
            row << ItemName.where(item_id: order.item_id, locale: 'en').take.name
            row << ""
            row << "KR"
            row << order.quantity
            row << "EA"
            row << order.item.sale_price
            row << ""
            row << ""
            row << ""
            csv << row
          end
        end
      end
    end

    # render plain: csv_output

    send_data csv_output, :type => 'text/csv; charset=iso-8859-1; header=present', :filename => DateTime.current().strftime("%Y%m%d")+" - UPS_Shipinfo_INV.csv"
  end

  ############ download YAMOOJIN #############
  collection_action :yamoojin_csv do

    csv_output = CSV.generate() do |csv|
      csv << ["수취고객명",
              "수취인",
              "수취인 전화",
              "수취인 휴대폰",
              "우편번호",
              "수취인 주소",
              "총중량",
              "상품명1",
              "수량1",
              "물품가격",
              "옵션",
              "메모",]

      
      collection.each do |resource|
        ### data_in ###
        # og = OrderGroup.grouping(resource.orders.valid.where(item_id: current_admin_user.items.pluck(:id)))
        og = OrderGroup.grouping(resource.filtered_orders(params[:q]).valid.where(item_id: current_admin_user.items.pluck(:id)))
        og.each_with_index do |order_group, index|
          order_group.orders.each_with_index do |order, sub_idx|
            row = []
            row << order.purchase.recipient
            row << ""
            row << ""
            row << fix_kr_phonenumber(order.purchase.user.country, order.purchase.phonenumber)
            row << order.purchase.postcode
            row << order.purchase.address
            row << order.item.weight * order.quantity
            row << order.item.display_name
            row << order.quantity
            row << order.item.sale_price * order.quantity

            #################  make option text  ###################
            options = Array.new(1) 
            order.order_option_items.each do |x|
              options << x.option_item.name if  x.option.option_type == 1
              options << x.option_text if  x.option.option_type == 2
            end
            options.compact!
            options = options.join(", ")
            #######################  end  ##########################
            row << options
            row << ""
            csv << row
          end
        end
      end
    end

    # Iconv set
    # conv = Iconv.new("EUC-KR//IGNORE","UTF-8")
    # csv_output = conv.iconv(csv_output)

    send_data csv_output, :type => 'text/csv; charset=iso-8859-1; header=present', :filename => DateTime.current().strftime("%Y%m%d") + " - Yamoojin (oppabox).csv"
  end

  ################## sidebar ##########################
  sidebar "다운로드", :only => :index do
    span do
      link_to "UPS BL", download_bl_admin_purchases_path(params.slice(:q, :scope)), { :class => "btn btn-default" }
    end
    span do
      link_to "UPS INV", download_inv_admin_purchases_path(params.slice(:q, :scope)), { :class => "btn btn-default" }
    end
    span do
      link_to "KR CSV", yamoojin_csv_admin_purchases_path(params.slice(:q, :scope)), { :class => "btn btn-default" }
    end
  end

  ################## filter ##########################
  filter :id
  filter :reference_number_contains, :label => "주문번호"
  filter :status, :as => :select, :collection => proc { Purchase::STATUSES.invert.map { |a,b| [t(a),b] } }, :label => "결제상태"
  filter :orders_status, :as => :select, :collection => proc { Order::STATUSES.invert.map { |a,b| [t(a),b] } }, :label => "주문상태"
  filter :approval_datetime, :label => "구매일자"
  filter :recipient_contains, :label => "수취인"
  filter :user_email_contains, :as => :string, :label => "Email"
  filter :user_country_eq, :as => :string, :label => "국가"
  filter :user_country_not_eq, :as => :string, :label => "제외한 모든 국가"
  filter :user_phonenumber_contains, :as => :string, :label => "전화번호"
  filter :orders_item_box_id, :as => :select, :collection => proc { current_admin_user.boxes.joins(:items).select("boxes.display_name, boxes.id").distinct.pluck("boxes.display_name, boxes.id") }, :label => "박스"
  filter :orders_item_id, :as => :select, :collection => proc { current_admin_user.items.map { |i| [i.display_name, i.id] } }, :label => "상품"
  filter :orders_order_periodic, :as => :numeric, :label => "정기구매"

  ################## view ##########################
  index :title => '주문 관리' do 
    column :id do |p|
      link_to p.id, admin_purchase_path(p)
    end
    column "주문번호", :reference_number
    column "결제 상태" do |p|
      status_string = Purchase::STATUSES.invert.keys
      para status_tag( t(status_string[p.status]), status_css[p.status] )
    end
    column "주문 내역(제품/수량(무게)/배송)" do |p|
      # o = p.orders.valid.where(item_id: current_admin_user.items.pluck(:id))
      o = p.filtered_orders(params[:q]).valid.where(item_id: current_admin_user.items.pluck(:id))
      og = OrderGroup.grouping(o)
      table class: "nested_table" do
        og.each_with_index do |order_group, index|
          cnt = order_group.orders.length
          order_group.orders.each_with_index do |order, sub_idx|
            # making option text
            periodic = if order.item.periodic or order.order_periodic > 1 then "(" + t("periodoc_#{order.order_periodic}month") + ")" else nil end
            options = Array.new(1){periodic}
            order.order_option_items.each do |x|
              options << x.option_item.name if  x.option.option_type == 1
              options << x.option_text if  x.option.option_type == 2
            end
            options.compact!
            options = options.join(", ")
            # render
            tr do 
              td do
                t(Order::STATUSES.invert.keys[order.status])
              end
              td do
                span order.item.display_name
                unless options == ""
                  br
                  small "[" + options + "]"
                end
              end
              td order.quantity.to_s + ' (' + order.item.weight.to_s + ')'
              if sub_idx == 0
                td rowspan: cnt do 
                  t(order.shipping.name) 
                end
              end
            end
          end
        end
      end
    end
    column "구매자 정보" do |p|
      para p.user.name + ' (' + p.user.country + ')'
      para p.user.email
      para p.phonenumber
    end
    column '수취인 / 주소 / 도시 / 우편번호' do |p|
      para p.recipient
      para p.address
      para p.city
      para p.postcode
    end
    column "결제금액(결제수단)" do |p|
      amt = p.amt.nil? ? "" : p.amt
      opt = Purchase::PAY_OPTIONS.invert[p.pay_option]
      opt = opt.nil? ? "" : opt
      para amt + " (" + opt + ")"
   end
    column "결제시간" do |p|
      dt = p.approval_datetime.nil? ? DateTime.strptime('20000101', '%Y%m%d') : p.approval_datetime
      span dt.strftime('%F')
      span dt.strftime('%R')
    end
    column "" do |p|
      para link_to "상세", { :action => :show, :id => p.id }, { :class => "btn btn-default margin_p" }
      
      if p.status == Purchase::STATUS_PENDING
        target = Purchase::STATUS_PAID
      else
        target = ''
      end
      unless target == ''
        para link_to "입금확인", { :action => :transition, :id => p.id, :target => target }, { :class => "btn btn-primary margin_p" }
      end
      
      if p.status != Purchase::STATUS_CANCEL and current_admin_user.master
        para link_to "구매취소", { :action => :cancel, :id => p.id }, { :class => "btn btn-danger margin_p" }
      end
    end
  end

  show :title => "주문 내역" do
    columns do

      column span: 2 do
        attributes_table do
          row :id
          row "주문번호" do |p|
            p.reference_number
          end
          row "주문상태" do |p|
            status_string = Purchase::STATUSES.invert.keys
            
            status_tag( t(status_string[p.status]), status_css[p.status] )
          end
          row "주문내역" do |p|
            p.orders.valid.map{|o| o.item.display_name}.join(" / ")
          end
          row "수취인" do |p|
            p.recipient
          end
          row "구매자 정보" do |p|
            para p.user.name + ' (' + p.user.country + ')'
            para p.user.email
          end
          row '주소 / 도시 / 우편번호' do |p|
            para p.address
            para p.city
            para p.postcode
          end
          row "전화번호" do |p|
            p.phonenumber
          end
          row "결제금액" do |p|
            p.amt
          end
          row "결제결과" do |p| 
            p.pay_type
          end
          row "결제수단" do |p|
            Purchase::PAY_OPTIONS.invert[p.pay_option]
          end
          row "결제시간" do |p|
            dt = p.approval_datetime.nil? ? DateTime.strptime('20000101', '%Y%m%d') : p.approval_datetime
            span dt.strftime('%F')
            span dt.strftime('%R')
          end
          active_admin_comments
        end
      end
      column span: 3 do
        panel "Order Details" do
          table class: 'table table-bordered option_table' do
            thead do
              th '배송'
              th 'ID'
              th '상태'
              th '상품명'
              th '수량(무게)'
              th class: "active", colspan: 3 do '옵션' end
              th ''
            end
            tbody do
              og = OrderGroup.grouping(resource.orders.valid.where(item_id: current_admin_user.items.pluck(:id)))
              og.each do |order_group|
                cnt = 0
                order_group.orders.each do |order|
                  tmp = order.order_option_items.count
                  tmp = tmp == 0 ? 1 : tmp
                  cnt += tmp
                end
                order_group.orders.each_with_index do |order, idx|
                  sub_cnt = order.order_option_items.count
                  if sub_cnt == 0
                    # no option
                    tr do
                      td rowspan: cnt do
                       span t(order.shipping.name) 
                       br
                       render :partial => "invoice_form", :locals => { :ids => order_group.ids, :order => order }
                     end
                      td order.id
                      td do
                        status_string = Order::STATUSES.invert.keys  
                        status_tag( t(status_string[order.status]), order_status_css[order.status] )
                      end
                      td do
                        span order.item.display_name
                        if order.item.periodic or order.order_periodic > 1
                          br
                          span "(" + t("periodoc_#{order.order_periodic}month") + ")"
                        end
                      end
                      td order.quantity.to_s + ' (' + order.item.weight.to_s + ')'
                      td colspan: 3
                      # actions
                      td do
                        case order.status
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
                          span link_to "진행", { :controller => "admin/orders", :action => :transition, :id => order.id, :target => target }, { :class => "btn btn-primary margin_p" }
                        end
                        
                        unless order.status == Order::STATUS_CANCEL
                          span link_to "취소", { :controller => "admin/orders", :action => :cancel, :id => order.id }, { :class => "btn btn-danger margin_p" }
                        end
                      end
                    end
                  else
                    order.order_option_items.each_with_index do |ooi, sub_idx|
                      tr do
                        if idx == 0 and sub_idx == 0
                          td rowspan: cnt do
                           span t(order.shipping.name) 
                           br
                           render :partial => "invoice_form", :locals => { :ids => order_group.ids, :order => order }
                         end
                        end
                        if sub_idx == 0
                          td rowspan: sub_cnt do order.id end
                          td rowspan: sub_cnt do
                            status_string = Order::STATUSES.invert.keys  
                            status_tag( t(status_string[order.status]), order_status_css[order.status] )
                          end
                          td rowspan: sub_cnt do order.item.display_name end
                          td rowspan: sub_cnt do order.quantity.to_s + ' (' + order.item.weight.to_s + ')' end
                        end
                        td ooi.option.title
                        if ooi.option_item_id == -1
                          render :partial => "/admin/orders/edit_options", :locals => { :target => "/admin/purchases/#{params[:id]}", :id => ooi.id, :type => "text", :data => ooi.option_text }
                        else
                          col = ooi.option.option_items.pluck(:name, :id)
                          render :partial => "/admin/orders/edit_options", :locals => { :target => "/admin/purchases/#{params[:id]}", :id => ooi.id, :type => "select", :data => ooi.option_item.id, :collection => col }
                        end
                        # actions
                        if sub_idx == 0
                          td rowspan: sub_cnt do
                            case order.status
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
                              span link_to "진행", { :controller => "admin/orders", :action => :transition, :id => order.id, :target => target }, { :class => "btn btn-primary margin_p" }
                            end
                            
                            unless order.status == Order::STATUS_CANCEL
                              span link_to "취소", { :controller => "admin/orders", :action => :cancel, :id => order.id }, { :class => "btn btn-danger margin_p" }
                            end
                          end
                        end
                      end
                    end
                  end
                end
              end
            end
          end

        end
      end

    end
  end


  controller do
    def scoped_collection
      super.distinct
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
end