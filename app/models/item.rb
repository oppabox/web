class Item < ActiveRecord::Base
  belongs_to  :box
  has_many    :options
  has_many    :item_images
  has_many    :item_names
  has_many    :orders
  has_many    :baskets

  def display_name
    self.item_names.where(:locale => I18n.locale.to_s).first.name
  end

end
