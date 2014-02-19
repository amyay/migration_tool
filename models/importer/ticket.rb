require 'csv'

class Importer::Ticket < Importer
  def initialize csv
    super csv
    @type = 'ticket'
  end

  def import_row row
    assignee_shortname = (Formatter::Shortname.new row['AR Owner']).formatted
    assignee = ::User::Agent.find_by_shortname assignee_shortname

    requester_email = (Formatter::Email.new row['Email']).formatted
    requester_name = (Formatter::Name.new row['Full Name']).formatted

    # first try to find requester via email
    requester = ::User.find_or_create_by_email requester_email

    # if email is not present, then try to find requester via full name
    if requester_email.nil? || requester_email.empty?
      # puts "cannot find user via email, try finding by full name"
      requester = ::User.find_by_name requester_name
    end

    # if requester can't be found, then create user with bogus email
    if requester.nil?
      # puts "cannot find user via full name. create bogus email for #{requester_name}"
      address = requester_name.gsub " ", "."
      domain = "legacymedidata.com"
      made_up_email = "#{address}@#{domain}"
      requester = ::User.find_or_create_by_email made_up_email
      requester.name = requester_name
    end
    requester.save!

    ticket = ::Ticket::Incident.new
    ticket.subject = row['AR Description']
    ticket.description = row['AR Description']
    ticket.created_at = (Formatter::Time.new row['Created Date']).formatted
    ticket.priority = (Formatter::Priority.new row['Urgency']).formatted
    ticket.status = row['AR Status']
    # get ticket.closed_at depending on status
    ticket.closed_at = (Formatter::Time.new row['Closed Date']).formatted if ticket.status.downcase == 'closed'
    ticket.requester = requester
    ticket.assignee = assignee

    # custom fields, e.g. Old Ticket ID
    ticket.legacy_id = row['AR #']
    ticket.sponsor_study = row['Sponsor'] + ' ' + row['Study']
    ticket.resolution = row['Resolution']

    ticket.save!
  end
end

class Importer::Ticket::Medidata < Importer::Ticket
  def initialize csv
    super
    @type = 'ticket'
  end
end
