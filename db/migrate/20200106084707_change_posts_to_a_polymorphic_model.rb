class ChangePostsToAPolymorphicModel < ActiveRecord::Migration[5.2]
  def change
    change_table :posts do |t|
      t.remove_index :user_id
      t.remove :user_id
      t.integer :postable_id
      t.string  :postable_type
    end
  end
end
