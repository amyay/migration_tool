class Special
  def initialize csv
    @csv = csv
    @logger = Logger.new STDOUT
    @type = ''
  end

  def export
    @logger.debug "Exporting tickets and comments together ..."
    # batch_size = 20000
    batch_size = 20
    count = 0

    ### loop thru all tickets ###
    begin
      processed = false

      # open files #
      outfile_ticket = File.open("./output/Tickets_#{sprintf('%02d',count)}.csv", "wb")
      outfile_comment = File.open("./output/Ticket_Comments_#{sprintf('%02d',count)}.csv", "wb")

      outfile_ticket << (["Ticket #", "Subject", "Description", "Creation Date [yyyy-MM-dd z]", "Closure Date [yyyy-MM-dd z]", "Requester [id]", "Group", "Assignee [id]", "Type", "Status", "Priority", "Tags", "Queue[23779816]", "Emailed To[23683173]", "User IP[23721196]", "WEB agent[23690807]", "Referrer URL[23690817]", "Web cookie[23683183]", "Thread ID[23721206]"]).join(',')
      outfile_ticket << "\n"

      outfile_comment << (["Ticket #", "Ticket Comment #", "Comment", "Creation Date [yyyy-MM-dd z]", "Author [id]", "Public"]).join(',')
      outfile_comment << "\n"

      innercount = 0
      # write individual ticket in within batchsize
      Ticket.offset(count*batch_size).limit(batch_size).each do |t|

        processed = true
        ticket_type = t.type.gsub 'Ticket::', ''

        ticket_quoted = Array.new
          [t.id, t.subject, t.description, (Formatter::Time.new t.created_at).formatted, (Formatter::Time.new t.closed_at).formatted, t.requester_id, Group.find_by_id(t.group_id).name, t.assignee_id, ticket_type, t.status, t.priority, t.tag, t.queue, t.emailed_to, t.userIP, t.WEbagent, t.ReferrerURL, t.Webcookie, t.ThreadId].each do |element|
          ticket_quoted << (Formatter::Quote.new element).formatted
        end
        outfile_ticket << ticket_quoted.join(',')
        outfile_ticket << "\n"

        # write corresponding comment for this ticket
        t.comments.find_each do |c|
          comment_quoted = Array.new
          [c.ticket_id, c.id, c.body, (Formatter::Time.new c.created_at).formatted, c.author_id, c.is_public].each do |element|
            comment_quoted << (Formatter::Quote.new element).formatted
          end
          outfile_comment << comment_quoted.join(',')
          outfile_comment << "\n"
        end
        innercount += 1
        @logger.debug "Processed #{innercount} tickets." if innercount % 500 == 0
      end # end of processing tickets in within batchsize

      @logger.debug "Processed #{innercount} tickets."
      @logger.info "Created ./output/Tickets_#{sprintf('%02d',count)}.csv"
      @logger.info "Created ./output/Ticket_Comments_#{sprintf('%02d',count)}.csv"
      count += 1

      break if count == 10

    end while processed
    # @logger.info "Processed ticketss and created two files"
  end


  def export2
    batch_size = 500
    count = 0
    begin
      processed = false

      # Open file
      outfilename_ticket = "Ticket_#{count}.csv"
      outfilename_comment = "Ticket_Comments_#{count}.csv"

      Ticket.offset(count*batch_size).limit(batch_size).each do |t|
        processed = true

        # export a ticket
        t.comments.each do |c|
          # export comments
        end
      end
      count += 1

      # Close files

    end while processed
  end
end