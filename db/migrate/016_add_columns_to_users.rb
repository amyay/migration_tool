class AddColumnsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :tag, :string
    add_column :users, :organization, :string
    add_column :users, :password, :string
    add_column :users, :details, :string
    add_column :users, :notes, :string
  end
end