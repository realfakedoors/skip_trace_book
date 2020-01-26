class CreateGroups < ActiveRecord::Migration[5.2]
  def change
    create_table :groups do |t|
      t.bigint :leader_id
      t.string :name
      t.string :description
      t.string :objective

      t.timestamps
    end
  end
end
