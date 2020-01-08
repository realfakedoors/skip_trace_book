class CreateFollowings < ActiveRecord::Migration[5.2]
  def change
    create_table :followings do |t|
      t.integer :page_id, index: true
      t.integer :follower_id, index: true

      t.timestamps
    end
  end
end
