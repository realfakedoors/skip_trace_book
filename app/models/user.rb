class User < ApplicationRecord
  has_many :posts,               as: :postable,   dependent: :destroy
  
  has_many :friendships,                          dependent: :destroy
  has_many :friends,        through: :friendships
  
  has_many :albums,                               dependent: :destroy
  has_many :photos,         through: :albums,     dependent: :destroy
  
  has_many :pages
  has_many :followings
  has_many :followed_pages, through: :followings,    source: "page"
  
  has_many :groups
  has_many :memberships
  has_many :joined_groups,  through: :memberships,   source: "group"
  
  has_many :direct_messages
  has_many :messages,       through: :direct_messages
  has_many :messages,       through: :discussions
  
  has_many :likes,                                dependent: :destroy
  has_many :comments,                             dependent: :destroy
  
  
  # Include default devise modules. Others available are:
  # :validatable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable,
         :confirmable, :lockable
         
  mount_uploader :profile_picture, PictureUploader
  
  before_save :downcase_email
  
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  
  validates :name,  presence: true, length: { maximum: 50 }
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  validates :encrypted_password, 
                    presence: true, length: { minimum: 6, maximum: 64 }
  validate  :profile_picture_size
  
  def send_friend_request(other_user)
    friends << other_user
  end
  
  def friend_request_sent?(other_user)
    friends.include?(other_user) || other_user.friends.include?(self)
  end
  
  def accept_friend_request(friendship)
    friendship.accepted = true
  end
  
  def decline_friend_request(friendship)
    friendship.destroy
  end
  
  def confirmed_friends?(other_user)
    friendship = Friendship.find_by(user: self, friend: other_user)
    friendship && friendship.accepted?
  end
  
  def unfriend(other_user)
    Friendship.find_by(user: self, friend: other_user).delete
  end
  
  def follow(page)
    page.followers << self
  end
  
  def unfollow(page)
    Following.find_by(user: self, page: page).delete
  end
                    
  private
  
    #converts an email address to all lower-case.
    def downcase_email
      email.downcase!
    end
  
    #Validates the size of a user's profile picture.
    def profile_picture_size
      if profile_picture.size > 5.megabytes
        errors.add(:profile_picture, "should be less than 5MB")
      end
    end    
end
