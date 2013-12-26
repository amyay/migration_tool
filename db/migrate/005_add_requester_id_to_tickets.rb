class AddRequesterIdToTickets < ActiveRecord::Migration
  def change
    add_column :tickets, :requester_id, :integer
  end
end
