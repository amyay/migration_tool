class AgentsGroup < ActiveRecord::Base
  has_and_belongs_to_many :agents, class_name: "User::Agent"
end