class Group < ApplicationRecord
  belongs_to :leader, class_name: "User", foreign_key: "user_id"
  
  has_many :memberships
  has_many :members, through: :memberships, source: "user"
  
  has_many :discussions, dependent: :destroy
  has_many :messages, through: :discussions
  
  has_many :photos, as:  :photo_attachable, dependent: :destroy
  
  mount_uploader :avatar, PictureUploader
  
  validates     :user_id, presence: true
  validates        :name, length: { maximum: 100 }, presence: true
  validates :description, length: { maximum: 100 }
  validates   :objective, length: { maximum: 500 }
  validate  :avatar_size
  
  def confirmed_members
    confirmed_memberships = self.memberships.where(confirmed: "true")
    confirmed_memberships.map{ |membership| User.find(membership.user_id) }
  end
  
  def unconfirmed_members
    unconfirmed_memberships = self.memberships.where(confirmed: "false")
    unconfirmed_memberships.map{ |membership| User.find(membership.user_id) }
  end
  
  def confirm(member)
    membership = self.memberships.find_by(user: member)
    membership.confirmed = true
    membership.save
  end
  
  private
  
    # Validates the size of a page's avatar.
    def avatar_size
      if avatar.size > 5.megabytes
        errors.add(:avatar, "should be less than 5MB")
      end
    end
end