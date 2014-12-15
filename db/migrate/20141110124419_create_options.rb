class CreateOptions < ActiveRecord::Migration
  def change
    create_table :options do |t|
      t.integer     :item_id
      t.string      :title
      t.integer     :option_type #1 : 일반적인 옵션(빨간색), 2 : 문자열 입력방식(제 이름을 새겨주세요.)

      t.timestamps
    end
  end
end
