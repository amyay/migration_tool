class AddCustomFieldsToTickets < ActiveRecord::Migration
  def change
    add_column :tickets, :legacy_id,   :string
    add_column :tickets, :queue,       :string
    add_column :tickets, :emailed_to,  :string
    add_column :tickets, :userIP,      :string
    add_column :tickets, :WEbagent,    :string
    add_column :tickets, :ReferrerURL, :string
    add_column :tickets, :Webcookie,   :string
    add_column :tickets, :ThreadId,    :string
  end
end