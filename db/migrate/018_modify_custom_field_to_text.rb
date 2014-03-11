class ModifyCustomFieldToText < ActiveRecord::Migration
  def change
    change_column :tickets, :ReferrerURL, :text
    change_column :tickets, :WEbagent,    :text
  end
end