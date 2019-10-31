class Friendship < ApplicationRecord
  belongs_to :user
  belongs_to :friend, class_name: "User"
  
  def friend_accepted?
    true if accepted? == true
  end
  
  def requested?
    true if accepted? == false
  end
end
