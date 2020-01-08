class ChangeFollowingToJoinTable < ActiveRecord::Migration[5.2]
  def change
    change_table :followings do |t|
      t.remove_index :follower_id
      t.remove_index :page_id
      t.remove :follower_id
      t.remove :page_id
      t.belongs_to :page, index: true
      t.belongs_to :user, index: true
    end
  end
end
