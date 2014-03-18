require 'csv'

class Exporter::User < Exporter
  def initialize csv
    super csv
    @type = 'User'
  end

  def export_header
    header_string = (["id", "Name", "Email", "Password", "Phone", "Role", "Organization", "Tags", "Details", "Notes"]).join(',')
    header_string
  end

  def export_row u
    if u.type.nil?
      user_type = "end user"
    else
      user_type = "agent"
    end

    quoted = Array.new
    [u.id, u.name, u.email, u.password, u.phone, user_type, u.organization, u.tag, u.details, u.notes].each do |element|
        quoted << (Formatter::Quote.new element).formatted
      end
      quoted.join(',')
  end
  def export_class
    ::User
  end

end
