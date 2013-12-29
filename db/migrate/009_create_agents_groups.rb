class CreateAgentsGroups < ActiveRecord::Migration
  def change
    create_table :agents_groups do |g|
      g.integer :agent_id
      g.integer :group_id
    end

    add_index :agents_groups, [:agent_id, :group_id]
  end
end
