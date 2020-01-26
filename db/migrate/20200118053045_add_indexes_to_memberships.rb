class AddIndexesToMemberships < ActiveRecord::Migration[5.2]
  def change
    add_index :memberships, :member_id
    add_index :memberships, :group_id
  end
end
