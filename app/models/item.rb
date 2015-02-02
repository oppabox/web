class Item < ActiveRecord::Base
  belongs_to  :box
  has_many    :options, :dependent => :destroy
  has_many    :item_images, :dependent => :destroy
  has_many    :item_names, :dependent => :destroy
  has_many    :orders, :dependent => :destroy
  has_many    :baskets, :dependent => :destroy
  has_many    :item_shippings, :dependent => :destroy
  has_many    :shippings, :through => :item_shippings

  after_destroy :remove_images

  def display_name
    self.item_names.where(:locale => I18n.locale.to_s).first.name
  end

  def image_url
    "/images/items/#{self.box.path}/#{self.path}/#{self.path}.jpg"
  end

  def image_locale_url loc, name
    "/images/items/#{self.box.path}/#{self.path}/#{loc}/#{name}.jpg"
  end

  def get_delivery_fee shipping_name, country, quantity = 1
    shipping = self.shippings.where(name: shipping_name).take
    fee = Shipping.calculate_box_delivery shipping.name, country, nil, self.weight, quantity
    fee.ceil
  end

  def shippings_in country
    if country == "KR"
      self.shippings.domestic
    else
      self.shippings.foreign
    end
  end

  protected
  def remove_images
  	# remove the dir
  	if !self.box.nil? and File.directory?(Rails.root.join('public', 'images', 'items', self.box.path, self.path))
  		FileUtils.remove_dir(Rails.root.join('public', 'images', 'items', self.box.path, self.path), true)
  	end
  end

end