class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.integer :ticket_id
      t.integer :author_id
      t.text :body
      t.boolean :is_public

      t.timestamps
    end
  end
end