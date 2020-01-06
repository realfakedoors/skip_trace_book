class CreatePages < ActiveRecord::Migration[5.2]
  def change
    create_table :pages do |t|
      t.string :name
      t.string :description
      t.string :location
      t.string :website
      t.string :mission

      t.timestamps
    end
  end
end
