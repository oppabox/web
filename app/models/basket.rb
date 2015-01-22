class Basket < ActiveRecord::Base
  belongs_to :user
  belongs_to :item

  scope :valid,              -> { where(deleted: false) }
end
