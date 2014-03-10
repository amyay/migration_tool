require 'csv'

class Exporter::Organization < Exporter
  def initialize csv
    super csv
    @type = 'Organization'
  end

  def export_header
    header_string = (["Name", "Details", "Notes", "Shared", "Shared Comments", "Domain"]).join(',')
    header_string
  end

  def export_row o
    quoted = Array.new
    [o.name, o.details, o.notes, o.shared, o.shared_comments, o.domain].each do |element|
        quoted << (Formatter::Quote.new element).formatted
      end
      quoted.join(',')
  end

  def export_class
    ::Organization
  end

end