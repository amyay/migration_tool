class AddLegacyIdAsIndexToTickets < ActiveRecord::Migration
    add_index :tickets, :legacy_id
end