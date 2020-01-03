class RemovePictureFromPosts < ActiveRecord::Migration[5.2]
  def change
    change_table :posts do |t|
      t.remove :picture
    end
  end
end
