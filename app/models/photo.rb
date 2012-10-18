class Photo < ActiveRecord::Base
  attr_accessible :image, :place_id

  belongs_to :place

  mount_uploader :image, PhotoUploader
end
