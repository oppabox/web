class Box < ActiveRecord::Base
  has_many :items, :dependent => :destroy
  
  validates :display_name, presence: true
  validates :path, uniqueness: true, format: { with: /\A[0-9a-z_]+\Z/ }

  after_destroy :remove_images

  scope :to_display,      -> { order('display_order DESC, id') }

  def top_image_url
    return "/images/top/#{self.path}.jpg"
  end

  def image_url
    return "/images/box/#{self.path}.jpg"
  end

  protected
  def remove_images
  	# image in box dir
    if File.file?(Rails.root.join('public', 'images', 'box', self.path + '.jpg'))
      File.delete(Rails.root.join('public', 'images', 'box', self.path + '.jpg'))
    end
    if File.file?(Rails.root.join('public', 'images', 'top', self.path + '.jpg'))
      File.delete(Rails.root.join('public', 'images', 'top', self.path + '.jpg'))
    end
  	# remove item wrapper dir
  	if File.directory?(Rails.root.join('public', 'images', 'items', self.path))
			FileUtils.remove_dir(Rails.root.join('public', 'images', 'items', self.path), true)
		end
  end

end
