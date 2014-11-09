class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.integer     :box_id
      t.string      :display_name
      t.string      :path

      t.timestamps
    end
  end
end
