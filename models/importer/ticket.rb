require 'csv'

class Importer::Ticket < Importer
  def initialize csv
    super csv
    @type = 'ticket'
  end

  def import_row row

    #### find assignee ####
    assignee = nil
    if row['Assignee'].include? '@'
      assignee_email = (Formatter::Email.new row['Assignee']).formatted
      assignee = ::User::Agent.find_or_create_by_email assignee_email
    else
      # Assignee field does not contain email address
      # check to see if Assignee field contains anything
      if !(row['Assignee'].nil? || row['Assignee'].empty?)
        # Assignee contains something
        # try searching by name
        assignee = ::User::Agent.find_by_name row['Assignee']
        if assignee.nil?
          # cannot find assignee
          # make up asignee
          address = row['Assignee'].gsub " ", "."
          domain = "legacyuser-tripadvisor.com"
          assignee_email = "#{address}@#{domain}"
          assignee = ::User::Agent.find_or_create_by_email assignee_email
        end
      end
    end

    #### find requester ####
    requester = nil
    if row['Requester'].include? '@'
      requester_email = (Formatter::Email.new row['Requester']).formatted
      requester = ::User.find_or_create_by_email requester_email
    else
      # Requester field does not contain email address
      # check to see if Requester field contains anything
      if !(row['Requester'].nil? || row['Requester'].empty?)
        # Requester contains something
        # try search by name
        requester = ::User.find_by_name row['Requester']
        if requester.nil?
          # cannot find requester
          # make up your own
          address = row['Requester'].gsub " ", "."
          domain = "legacyuser-tripadvisor.com"
          requester_email = "#{address}@#{domain}"
          requester = ::User.find_or_create_by_email requester_email
        end
      end
    end

    #### create ticket ####
    ticket_type = type_to_ticket_class row['Type']
    ticket = ticket_type.new

    ticket.subject = row['Subject']
    ticket.description = row['DESCRIPTION']
    ticket.created_at = (Formatter::Time.new row['Create Date']).formatted
    ticket.priority = (Formatter::Priority.new row['Priority']).formatted
    ticket.status = row['Status']
    # get ticket.closed_at depending on status
    ticket.closed_at = (Formatter::Time.new row['Closure Date']).formatted if ticket.status.downcase == 'closed'
    ticket.group_id = Group.find_or_create_by_name(row['Group']).id
    ticket.tag = row['Tags'] + ' legacy_tickets_2014_03_14'
    ticket.requester = requester
    ticket.assignee = assignee


    # custom fields, e.g. Old Ticket ID
    ticket.legacy_id = row['Ticket#']
    ticket.queue = row['queue']
    ticket.emailed_to = row['Emailed To']
    ticket.userIP = row['UserIP']
    ticket.WEbagent = row['WEbagent']
    ticket.ReferrerURL = row['ReferrerURL']
    ticket.Webcookie = row['Webcookie']
    ticket.ThreadId = row['ThreadId']

    ticket.save!

    ticket.reload
    if ticket.legacy_id=='06649813'
      puts "***"
      puts ticket.inspect
      # ticket.legacy_id = nil
      # ticket.save!
      # puts "***"
      # puts ticket.inspect
    end
    puts "bad validation for ticket #{ticket.legacy_id}" if ticket.requester_id.nil?
  end

  private
    def type_to_ticket_class type
      case type.downcase
      when 'question'
        return ::Ticket::Question
      when 'incident'
        return ::Ticket::Incident
      when 'task'
        return ::Ticket::Task
      when 'problem'
        return ::Ticket::Problem
      else
        raise "Unknown type: #{type}"
      end
    end
end

