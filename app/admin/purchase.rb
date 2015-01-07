ActiveAdmin.register Purchase do

  scope :all, default: true
  scope :purchase_paid
  scope :purchase_pending
  scope :user_kr
  scope :user_not_kr


  index do 
    column :id do |p|
      link_to p.id, admin_purchase_path(p)
    end
    column "status" do |p|
      status_string = Purchase::STATUSES.invert.keys
      status_css = ['', 'warning', 'error', 'complete']
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
  end

  show do
    columns do

      column do
        attributes_table do
          row :id
          row "status" do |p|
            status_string = Purchase::STATUSES.invert.keys
            status_css = ['', 'warning', 'error', 'complete']
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
