class AdminUser < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, 
         :recoverable, :rememberable, :trackable, :validatable

  has_many :boxes, :dependent => :destroy

  def items
  	Item.includes(:box).where(box_id: self.boxes.pluck(:id))
  end

  def orders
  	Order.includes(:item).where(item_id: self.items.pluck(:id))
  end

  def purchases
  	Purchase.where(id: self.orders.pluck(:purchase_id).uniq)
  end

  def cancels
  	Cancel.where(order_id: self.orders.pluck(:id))
  end

  def returns
  	Return.where(order_id: self.orders.pluck(:id))
  end

  def changes
  	Change.where(order_id: self.orders.pluck(:id))
  end

end
