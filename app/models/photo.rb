class Photo < ApplicationRecord
  belongs_to :photo_attachable, polymorphic: true
  
  default_scope -> { order('created_at DESC') }
  
  mount_uploader :photo_data, PictureUploader
  
  validate  :photo_size
  
  private
  
    def photo_size
      if photo_data.size > 5.megabytes
        errors.add(:photo_data, "should be less than 5MB")
      end
    end
end
