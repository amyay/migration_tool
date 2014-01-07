require 'csv'

class Importer::Agent < Importer
  def initialize csv
    super csv
    @type = 'agent'
  end

  def import_row row
    email = Formatter::Email.new row['Email']
    name = Formatter::Name.new row['Name']
    phone = Formatter::Phone.new row['Phone']
    user = ::User::Agent.find_or_create_by_email email.formatted
    user.name = name.formatted
    user.phone = phone.formatted

    group = ::Group.find_or_create_by_name row['Group']
    user.groups << group
    user.save!
  end
end