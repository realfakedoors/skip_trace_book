class Friendship < ApplicationRecord
  belongs_to :user
  belongs_to :friend, class_name: "User"
  
  def create_inverse_friendship
    unless self.class.exists?(user_id: friend_id, friend_id: user_id)
      self.class.create( { user_id: friend_id, friend_id: user_id, accepted: true } )
    end
  end
  
  def friend_accepted?
    true if accepted? == true
  end
  
  def requested?
    true if accepted? == false
  end
end
