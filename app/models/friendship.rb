class Friendship < ApplicationRecord
  belongs_to :user
  belongs_to :friend, class_name: "User"
  
  def friend_accepted?
    true if self.accepted? == true
  end
  
  def requested?
    true if self.accepted? == false
  end
end
