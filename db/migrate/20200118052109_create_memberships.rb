class CreateMemberships < ActiveRecord::Migration[5.2]
  def change
    create_table :memberships do |t|
      t.bigint :group_id
      t.bigint :member_id

      t.timestamps
    end
  end
end
