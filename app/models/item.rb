class Item < ActiveRecord::Base
  belongs_to  :box
  has_many    :options, :dependent => :destroy
  has_many    :item_images, :dependent => :destroy
  has_many    :item_names, :dependent => :destroy
  has_many    :orders
  has_many    :baskets

  def display_name
    self.item_names.where(:locale => I18n.locale.to_s).first.name
  end

end