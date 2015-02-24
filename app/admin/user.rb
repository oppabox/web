ActiveAdmin.register User do
  menu label: "유저 정보", :priority => 8
  config.batch_actions = false
  # remove action items
  config.clear_action_items!

  index :title => '유저 관리' do
    column :id
    column :option_flag
    column :name
    column :country
    column :phonenumber
    column :postcode
    column :address
    column :city
    column :state
    column :email
    column :created_at
    column :current_sign_in_at
  end

end
