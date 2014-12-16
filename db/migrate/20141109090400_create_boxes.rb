class CreateBoxes < ActiveRecord::Migration
  def change
    create_table :boxes do |t|
      t.string      :display_name
      t.string      :path
      t.boolean     :opened,  :default => true

      t.timestamps
    end
  end
end
