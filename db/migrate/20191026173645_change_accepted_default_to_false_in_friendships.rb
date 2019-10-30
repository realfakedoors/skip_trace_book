class ChangeAcceptedDefaultToFalseInFriendships < ActiveRecord::Migration[5.2]
  def change
    change_column_null    :friendships, :accepted, false
    change_column_default :friendships, :accepted, from: nil, to: false
  end
end
