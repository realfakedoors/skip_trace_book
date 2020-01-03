class Album < ApplicationRecord
  belongs_to :user
  has_many   :photos, as: :photo_attachable, dependent: :destroy
  default_scope -> { order('created_at DESC') }
  
  def preview
    self.photos.last
  end
end
