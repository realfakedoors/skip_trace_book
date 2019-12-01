class Friendship < ApplicationRecord
  belongs_to :user
  belongs_to :friend, class_name: "User"
  
  after_update   :create_inverse_friendship
  after_destroy :destroy_inverse_friendship
  
  def friend_accepted?
    true if accepted? == true
  end
  
  def requested?
    true if accepted? == false
  end
  
  private
  
  def create_inverse_friendship
    Friendship.create(user: friend, friend: user, accepted: true)
  end
  
  def destroy_inverse_friendship
    Friendship.find_by(user: friend, friend: user).delete
  end
end
