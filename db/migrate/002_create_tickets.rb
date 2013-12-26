class CreateTickets < ActiveRecord::Migration
  def change
    create_table :tickets do |t|
      t.string :subject
      t.text :description
      t.timestamp :closed_at
      t.string :priority
      t.string :status

      t.timestamps
    end
  end
end
