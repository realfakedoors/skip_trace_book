class AddAvatarToPages < ActiveRecord::Migration[5.2]
  def change
    add_column :pages, :avatar, :string
  end
end
