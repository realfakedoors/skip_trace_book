class Message < ApplicationRecord
  belongs_to :user
  
  belongs_to :messageable, polymorphic: true
  
  has_many   :likes, as: :likable,          dependent: :destroy
  
  has_one    :photo, as: :photo_attachable, dependent: :destroy
  
  default_scope -> { order('created_at ASC') }
  
  validates :content, presence: true, length: { maximum: 1000 }
  
  accepts_nested_attributes_for :photo
end
