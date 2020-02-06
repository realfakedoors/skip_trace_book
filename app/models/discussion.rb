class Discussion < ApplicationRecord
  belongs_to :group
  
  has_many :messages, as: :messageable, dependent: :destroy
  
  validates :group_id, presence: true
  
  accepts_nested_attributes_for :messages
end
