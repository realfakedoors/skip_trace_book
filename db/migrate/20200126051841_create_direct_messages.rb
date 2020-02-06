class CreateDirectMessages < ActiveRecord::Migration[5.2]
  def change
    create_table :direct_messages do |t|
      t.bigint :initiator_id, foreign_key: true
      t.bigint :recipient_id, foreign_key: true

      t.timestamps
    end
  end
end
