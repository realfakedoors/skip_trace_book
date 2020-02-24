class Comment < ApplicationRecord
  belongs_to :user
  
  belongs_to :commentable, polymorphic: true
  
  has_many   :likes, as: :likable, dependent: :destroy
  
  validates :content, presence: true, length: { in: 5..200 }
end
