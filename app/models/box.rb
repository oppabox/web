class Box < ActiveRecord::Base
  has_many :items, :dependent => :destroy
  has_many :children, class_name: "Box", foreign_key: "parent_id", :dependent => :destroy
  belongs_to :parent, class_name: "Box"
  belongs_to :admin_user
  
  validates :display_name, presence: true
  validates :path, uniqueness: true, format: { with: /\A[0-9a-z_]+\Z/ }

  after_destroy :remove_images

  scope :sorted,      -> { order('display_order DESC, id') }
  scope :top,         -> { where(parent_id: nil) }

  def top_image_url
    "/images/top/#{self.path}.jpg"
  end

  def top_image_path
    Box.top_image_path(self.path)
  end

  def image_url
    "/images/box/#{self.path}.jpg"
  end

  def image_path
    Box.image_path(self.path)
  end

  def item_path
    Box.item_path(self.path)
  end

  def self.top_image_path path
    Rails.root.join('public', 'images', 'top', path + '.jpg')
  end

  def self.image_path path
    Rails.root.join('public', 'images', 'box', path + '.jpg')
  end

  def self.item_path path
    Rails.root.join('public', 'images', 'items', path)
  end

  def has_children?
    self.children != []
  end

  def self.master_box_filter
    scope :top, -> { where(parent_id: nil) }
  end

  def self.user_box_filter(current_admin_user)
    # 최상위 박스만 출력
    unless where(admin_user_id: current_admin_user.id).blank?
      top_box_id = where(admin_user_id: current_admin_user.id).first.id 
      scope :top, -> { where(id: top_box_id) }
    else
      self.master_box_filter
    end 
  end

  def self.new_box_select(current_admin_user, box_selected)
    box_list = Array.new
    if box_selected.nil?
      box_list = Box.where(public_flag: true).pluck(:display_name, :id)
      box_list += Box.where(admin_user_id: current_admin_user.id).limit(1).pluck(:display_name, :id)
    else
      box_list = Box.where(id: box_selected).pluck(:display_name, :id)
    end

    return box_list
  end

  protected
  def remove_images
  	# image in box dir
    if File.file?(self.image_path)
      File.delete(self.image_path)
    end
    if File.file?(self.top_image_path)
      File.delete(self.top_image_path)
    end
  	# remove item wrapper dir
  	if File.directory?(self.item_path)
			FileUtils.remove_dir(self.item_path, true)
		end
  end

end
