class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |u|
      u.string :email
      u.string :name
      u.string :phone

      u.timestamps
    end

    add_index :users, :email
  end
end
