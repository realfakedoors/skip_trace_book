class ChangeMemberIdToUserIdInMemberships < ActiveRecord::Migration[5.2]
  def change
    remove_index :memberships, :member_id
    rename_column :memberships, :member_id, :user_id
    add_index :memberships, :user_id
  end
end
