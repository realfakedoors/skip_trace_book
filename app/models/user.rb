class User < ApplicationRecord
  
  has_many :posts,       dependent: :destroy
  has_many :friendships, dependent: :destroy
  has_many :friends,     through:   :friendships
  
  # Include default devise modules. Others available are:
  # :validatable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable,
         :confirmable, :lockable
  
  before_save :downcase_email
  
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  
  validates :name,  presence: true, length: { maximum: 50 }
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  validates :encrypted_password, 
                    presence: true, length: { minimum: 6, maximum: 64 }
                    
  def feed
    Post.where("user_id = ?", id)
  end
  
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
    friends.delete(other_user)
  end
                    
  private
  
    #converts an email address to all lower-case.
    def downcase_email
      email.downcase!
    end
    
end
