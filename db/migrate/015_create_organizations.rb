class CreateOrganizations < ActiveRecord::Migration
  def change
    create_table :organizations do |u|
      u.string :name
      u.string :details
      u.string :notes
      u.boolean :shared
      u.boolean :shared_comments
      u.string :domain

      u.timestamps
    end

    add_index :organizations, :name
  end
end