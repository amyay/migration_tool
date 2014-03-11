class ModifyCustomFieldReferrerUrl < ActiveRecord::Migration
  def change
    change_column :tickets, :ReferrerURL, :text
  end
end