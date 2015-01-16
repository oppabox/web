include ActionView::Helpers::NumberHelper
class Order < ActiveRecord::Base
  belongs_to  :item
  belongs_to  :purchase
  has_many    :order_option_items
  has_one     :return, dependent: :destroy
  has_one     :cancel, dependent: :destroy
  has_one     :change, dependent: :destroy
  
  before_save :period_check, :quantity_check

  scope :purchase_paid,      -> { valid.joins(:purchase).where(purchases: {status: Purchase::STATUS_PAID}) }
  scope :purchase_pending,   -> { valid.joins(:purchase).where(purchases: {status: Purchase::STATUS_PENDING}) }
  scope :user_kr,            -> { valid.joins(purchase: :user).where("users.country = ?", "KR") }
  scope :user_not_kr,        -> { valid.joins(purchase: :user).where("users.country != ?", "KR") }
  scope :except_ordering,    -> { valid.joins(:purchase).where.not(purchases: {status: Purchase::STATUS_ORDERING}) }
  scope :valid,              -> { where.not(status: STATUS_DELETED) }
  scope :on_ordering,        -> { where(status: STATUS_ORDERING) }

  STATUS_ORDERING = 0
  STATUS_READY = 1
  STATUS_ON_DELIVERY = 2
  STATUS_DONE = 3
  STATUS_CANCEL = 4
  STATUS_DELETED = 5

  STATUSES = {
    STATUS_ORDERING => "STATUS_ORDERING",
    STATUS_READY => "STATUS_READY",
    STATUS_ON_DELIVERY => "STATUS_ON_DELIVERY",
    STATUS_DONE => "STATUS_DONE",
    STATUS_CANCEL => "STATUS_CANCEL",
    STATUS_DELETED => "STATUS_DELETED"
  }


  def quantity_check
    if self.quantity.nil? or self.quantity.to_s.empty? or self.quantity <= 0 
      self.quantity = 1
    end

    if self.quantity > self.item.buy_limit 
      self.quantity = self.item.buy_limit
    end

    if (self.item.limited == true) and (self.quantity > self.item.quantity)
      self.quantity = self.item.quantity
    end

    #option limits
    self.order_option_items.each do |x|
      if (!x.option_item.nil?) and (x.option_item.limited == true) and (self.quantity > x.option_item.quantity)
        self.quantity = x.option_item.quantity
      end
    end
  end

  def period_check
    if ![1,3,6,12].include? self.order_periodic
      self.order_periodic = 1
    end
  end

  def self.change_currency money
    "#{number_with_delimiter(money)} KRW (#{number_with_delimiter(Order.usd_from_krw(money))} USD)".html_safe
  end

  def self.usd_from_krw money
    (money.to_f / CURRENCY).round(2)
  end

  def total_price
    sum = self.item.sale_price
    self.order_option_items.each do |x|
      if !x.option_item_id.nil? and x.option_item_id > 0
        sum += x.option_item.price_change
      end
    end
    sum * self.order_periodic
  end

  def has_return?
    !self.return.nil?
  end

  def has_cancel?
    !self.cancel.nil?
  end

  def has_change?
    !self.change.nil?
  end

  def has_request?
    self.has_return? or self.has_cancel? or self.has_change?
  end
end
