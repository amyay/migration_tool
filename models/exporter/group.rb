require 'csv'

class Exporter::Group < Exporter
  def initialize csv
    super csv
    @type = 'Group'
  end

  def export_header
    header_string = (["Name", "Agents"]).join(',')
    header_string
  end

  def export_row ag
    group = ::Group.find_by_id ag.group_id
    agent = ::User::Agent.find_by_id ag.agent_id

    quoted = Array.new
    [group.name, agent.name].each do |element|
        quoted << (Formatter::Quote.new element).formatted
      end
      quoted.join(',')
  end

  def export_class
    ::AgentsGroup
  end

end
