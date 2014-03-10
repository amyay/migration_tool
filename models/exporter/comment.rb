require 'csv'

class Exporter::Comment < Exporter
  def initialize csv
    super csv
    @type = 'Ticket_Comment'
  end

  def export_header
    header_string = (["Ticket #", "Ticket Comment #", "Comment", "Creation Date [yyyy-MM-dd z]", "Author [id]", "Public"]).join(',')
    header_string
  end

  def export_row c

    quoted = Array.new
    [c.ticket_id, c.id, c.body, c.created_at, c.author_id, c.is_public].each do |element|
        quoted << (Formatter::Quote.new element).formatted
      end
      quoted.join(',')
  end
  def export_class
    ::Comment
  end

end
