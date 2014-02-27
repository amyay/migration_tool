class AddTagToTickets < ActiveRecord::Migration
  def change
    add_column :tickets, :tag, :string
  end
end