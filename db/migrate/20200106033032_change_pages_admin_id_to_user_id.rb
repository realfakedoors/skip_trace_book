class ChangePagesAdminIdToUserId < ActiveRecord::Migration[5.2]
  def change
    change_table :pages do |t|
      t.remove :admin_id
      t.integer :user_id
    end
  end
end
