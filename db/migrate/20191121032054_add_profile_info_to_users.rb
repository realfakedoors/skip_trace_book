class AddProfileInfoToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :occupation, :string
    add_column :users, :company, :string
    add_column :users, :location, :string
    add_column :users, :birthday, :date
  end
end
