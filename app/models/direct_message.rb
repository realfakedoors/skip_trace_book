class DirectMessage < ApplicationRecord
  belongs_to :initiator, class_name: "User"
  belongs_to :recipient, class_name: "User"
  
  has_many :messages, as: :messageable, dependent: :destroy
  
  validates :initiator_id, presence: true
  validates :recipient_id, presence: true
  
  accepts_nested_attributes_for :messages
  
  def other_user(user)
    user == self.initiator ? self.recipient : self.initiator
  end
end
