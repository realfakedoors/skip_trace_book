class AddAdminIdToPages < ActiveRecord::Migration[5.2]
  def change
    add_column :pages, :admin_id, :integer
  end
end
