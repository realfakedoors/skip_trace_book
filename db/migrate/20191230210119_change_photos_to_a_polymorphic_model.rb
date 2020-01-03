class ChangePhotosToAPolymorphicModel < ActiveRecord::Migration[5.2]
  def change
    change_table :photos do |t|
      t.remove_index :album_id
      t.remove :album_id
      t.integer :photo_attachable_id
      t.string :photo_attachable_type
    end
  end
end
