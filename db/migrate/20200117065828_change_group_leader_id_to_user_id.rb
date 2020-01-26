class ChangeGroupLeaderIdToUserId < ActiveRecord::Migration[5.2]
  def change
    change_table :groups do |t|
      t.rename :leader_id, :user_id
    end
  end
end
