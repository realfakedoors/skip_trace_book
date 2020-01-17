class Page < ApplicationRecord
  belongs_to    :admin, class_name: "User",    foreign_key: "user_id"
  
  has_many  :posts, as: :postable,         dependent: :destroy
  has_many :photos, as: :photo_attachable, dependent: :destroy
  
  has_many :followings
  has_many  :followers, through: :followings,  source: "user"
  
  mount_uploader :avatar, PictureUploader
  
  VALID_URL_REGEX = /\A(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(:[0-9]{1,5})?(\/.*)?\z/ix
  
  validates     :user_id, presence: true
  validates        :name, length: { maximum: 100 }, presence: true
  validates :description, length: { maximum: 100 }
  validates    :location, length: { maximum: 100 }
  validates     :website, length: { maximum: 200 },
                          format: {    with: VALID_URL_REGEX,
                                    message: "Enter a valid, full URL!" }
  validates     :mission, length: { maximum: 500 }
  validate  :avatar_size
  
  private
  
    # Validates the size of a page's avatar.
    def avatar_size
      if avatar.size > 5.megabytes
        errors.add(:avatar, "should be less than 5MB")
      end
    end
end
