include ActionView::Helpers::NumberHelper
class Order < ActiveRecord::Base
  belongs_to  :item
  belongs_to  :purchase
  has_many    :order_option_items
  has_one     :return, dependent: :destroy
  
  before_save :period_check, :quantity_check

  scope :purchase_paid,      -> {Order.valid.joins(:purchase).where(purchases: {status: PURCHASE_PAID})}
  scope :purchase_pending,   -> {Order.valid.joins(:purchase).where(purchases: {status: PURCHASE_PENDING})}
  scope :user_kr,            -> {Order.valid.joins(purchase: :user).where("users.country = ?", "KR")}
  scope :user_not_kr,        -> {Order.valid.joins(purchase: :user).where("users.country != ?", "KR")}
  scope :except_ordering,    -> {Order.valid.joins(:purchase).where.not(purchases: {status: PURCHASE_ORDERING})}
  scope :valid,              -> {Order.where(deleted: false)}
  # scope :purchase_paid,      -> {Order.where(deleted: false).joins(:purchase).where(purchases: {status: 1})}
  # scope :purchase_pending,   -> {Order.where(deleted: false).joins(:purchase).where(purchases: {status: 2})}
  # scope :user_kr,            -> {Order.where(deleted: false).joins(purchase: :user).where("users.country = ?", "KR")}
  # scope :user_not_kr,        -> {Order.where(deleted: false).joins(purchase: :user).where("users.country != ?", "KR")}


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
end
