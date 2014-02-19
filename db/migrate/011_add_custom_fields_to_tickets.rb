class AddCustomFieldsToTickets < ActiveRecord::Migration
  def change
    add_column :tickets, :legacy_id, :string
    add_column :tickets, :sponsor_study, :string
    add_column :tickets, :resolution, :string
  end
end