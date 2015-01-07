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

  index do
    column :id
    column "status" do |o|
      status_string = Purchase::STATUSES.invert.keys
      status_string[o.purchase.status]
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
    column :updated_at
    column :created_at
    column "Done" do |o|
      link_to "done", { :action => :change_status_to_done, :id => o.id }, {:class => "done_btn", :style => "border-radius: 4px;font-size: 14px;font-weight: bold;line-height: 200%;text-decoration: none !important;background: white;background: -webkit-linear-gradient(-90deg, white, #e7e7e7);background: -moz-linear-gradient(-90deg, white, #e7e7e7);background: linear, 180deg, white, #e7e7e7;box-shadow: 0 1px 1px rgba(0, 0, 0, 0.1), 0 1px 0 0 rgba(255, 255, 255, 0.8) inset;border: solid 1px #c7c7c7;border-color: #c7c7c7;padding: 3px 5px;color: #5e6469 !important;"}
    end
  end

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
