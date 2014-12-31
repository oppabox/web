ActiveAdmin.register Purchase do

  index do 
    column "status" do |p|
      status_string = ["주문중", "결제 완료", "무통장입금확인필요", "배송완료"]
      status_string[p.status]
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
