class User < ApplicationRecord
  
  has_many :posts, dependent: :destroy
  
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
                    
  private
  
    #converts an email address to all lower-case.
    def downcase_email
      email.downcase!
    end
    
end
