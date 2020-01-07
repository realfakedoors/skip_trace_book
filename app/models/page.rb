class Page < ApplicationRecord
  belongs_to :admin, class_name: "User", foreign_key: "user_id"
  has_many :posts,  as: :postable,         dependent: :destroy
  has_many :photos, as: :photo_attachable, dependent: :destroy
end
