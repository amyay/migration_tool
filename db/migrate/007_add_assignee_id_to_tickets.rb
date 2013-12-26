class AddAssigneeIdToTickets < ActiveRecord::Migration
  def change
    add_column :tickets, :assignee_id, :integer
  end
end
