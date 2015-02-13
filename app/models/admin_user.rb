class AdminUser < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, 
         :recoverable, :rememberable, :trackable, :validatable

  has_many :boxes, :dependent => :destroy
  has_many :group_shippings, :dependent => :destroy

  def boxes
    if self.master
      Box.all
    else
      Box.where(admin_user_id: self.id)
    end
  end

  def items
    if self.master
      Item.all
    else
  	 Item.includes(:box).where(box_id: self.boxes.pluck(:id))
    end
  end

  def orders
    if self.master
      Order.all
    else
  	 Order.includes(:item).where(item_id: self.items.pluck(:id))
    end
  end

  def purchases
    if self.master
      Purchase.all
    else
  	 Purchase.where(id: self.orders.pluck(:purchase_id).uniq)
    end
  end

  def cancels
    if self.master
      Cancel.all
    else
  	 Cancel.where(order_id: self.orders.pluck(:id))
    end
  end

  def returns
    if self.master
      Return.all
    else
  	 Return.where(order_id: self.orders.pluck(:id))
    end
  end

  def changes
    if self.master
      Change.all
    else
  	 Change.where(order_id: self.orders.pluck(:id))
    end
  end

  def group_shippings
    if self.master
      GroupShipping.all
    else
      GroupShipping.where(admin_user_id: self.id)
    end
  end

end
