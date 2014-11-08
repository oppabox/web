class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.boolean :flag_option #세부 개인정보 플래그
      t.string :country
      t.string :phonenumber
      t.string :postcode
      t.string :address

      t.timestamps
    end
  end
end
