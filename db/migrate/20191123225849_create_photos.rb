class CreatePhotos < ActiveRecord::Migration[5.2]
  def change
    create_table :photos do |t|
      t.references :album, foreign_key: true
      t.string :photo_data
      t.string :title
      t.string :description

      t.timestamps
    end
  end
end
