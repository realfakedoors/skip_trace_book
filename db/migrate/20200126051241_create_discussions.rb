class CreateDiscussions < ActiveRecord::Migration[5.2]
  def change
    create_table :discussions do |t|
      t.references :group, foreign_key: true
      t.string :title
      t.timestamps
    end
  end
end
