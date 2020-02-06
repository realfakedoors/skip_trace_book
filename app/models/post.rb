class Post < ApplicationRecord
  belongs_to :postable, polymorphic: true
  
  has_one    :photo, as: :photo_attachable, dependent: :destroy
  
  accepts_nested_attributes_for :photo
  
  default_scope -> { order('created_at DESC') }
  
  validates :postable_id,   presence: true
  validates :postable_type, presence: true
  validates :content,       presence: true, length: { maximum: 280 }
end
