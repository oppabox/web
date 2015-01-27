class Item < ActiveRecord::Base
  belongs_to  :box
  has_many    :options, :dependent => :destroy
  has_many    :item_images, :dependent => :destroy
  has_many    :item_names, :dependent => :destroy
  has_many    :orders, :dependent => :destroy
  has_many    :baskets, :dependent => :destroy

  after_destroy :remove_images

  def display_name
    self.item_names.where(:locale => I18n.locale.to_s).first.name
  end

  def image_url
    return "/images/items/#{self.box.path}/#{self.path}/#{self.path}.jpg"
  end

  protected
  def remove_images
  	# remove the dir
  	if !self.box.nil? and File.directory?(Rails.root.join('public', 'images', 'items', self.box.path, self.path))
  		FileUtils.remove_dir(Rails.root.join('public', 'images', 'items', self.box.path, self.path), true)
  	end
  end

end