class CreateGroups < ActiveRecord::Migration
  def change
    create_table :groups do |u|
      u.string :name

      u.timestamps
    end

    add_index :groups, :name
  end
end
