class AddGroupToTickets < ActiveRecord::Migration
  def change
    add_column :tickets, :group_id, :integer
  end
end