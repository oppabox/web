ActiveAdmin.register User do
  config.batch_actions = false

  index do
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
