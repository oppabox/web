class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.boolean :option_flag,     :default => false #세부 개인정보 플래그
      t.string :country
      t.string :phonenumber
      t.string :postcode
      t.string :address

      t.timestamps
    end
  end
end