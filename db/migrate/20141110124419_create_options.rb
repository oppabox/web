class CreateOptions < ActiveRecord::Migration
  def change
    create_table :options do |t|
      t.integer     :item_id
      t.string      :title
      t.integer     :option_type #1 : 일반적인 옵션(빨간색), 2 : 문자열 입력방식(제 이름을 새겨주세요.)

      # optins of option
      t.integer     :max_length,    :default => 20 #옵션타입2 일때, 최대 길이 
      t.boolean     :english_only,  :default => false #옵션타입2일때, 영문만 받는지 여부

      t.timestamps
    end
  end
end
