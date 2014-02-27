require 'csv'

class Exporter::Ticket < Exporter
  def initialize csv
    super csv
    @type = 'Ticket'
  end

  def export_header
    header_string = (["Ticket #", "Subject", "Description", "Creation Date [yyyy-MM-dd z]", "Closure Date [yyyy-MM-dd z]", "Requester [id]", "Group", "Assignee [id]", "Type", "Status", "Priority", "Tags", "Old Ticket ID [23701016]", "Urgency [23356527]", "Sponsor / Study [23639317]","Resolution [23669777]"]).join(',')
    header_string
  end

  def export_row t
    if t.assignee.nil? || t.assignee.groups.first.nil?
      ticket_group = ''
    else
      ticket_group = t.assignee.groups.first.name
    end

    ticket_type = t.type.gsub 'Ticket::', ''

    quoted = Array.new
    [t.id, t.subject, t.description, t.created_at, t.closed_at, t.requester_id, ticket_group, t.assignee_id, ticket_type, t.status, t.priority, '', t.legacy_id, t.sponsor_study, t.resolution].each do |element|
        quoted << (Formatter::Quote.new element).formatted
      end
      quoted.join(',')
  end

  def export_class
    ::Ticket
  end

end
