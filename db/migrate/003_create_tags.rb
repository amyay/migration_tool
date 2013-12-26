class CreateTags < ActiveRecord::Migration
  def change
    create_table :tags do |t|
      t.string :name
    end

    create_table :tags_users do |t|
      t.integer :tag_id
      t.integer :user_id
    end

    create_table :tags_tickets do |t|
      t.integer :tag_id
      t.integer :ticket_id
    end

    add_index :tags, :name
    add_index :tags_users, [:tag_id, :user_id]
    add_index :tags_tickets, [:tag_id, :ticket_id]
  end
end
