class CreateMessages < ActiveRecord::Migration[5.2]
  def change
    create_table :messages do |t|
      t.bigint :messageable_id
      t.string :messageable_type
      t.bigint :user_id
      t.string :content

      t.timestamps
    end
  end
end
