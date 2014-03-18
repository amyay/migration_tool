class Special4
  def initialize csv
    @csv = csv
    @logger = Logger.new STDOUT
    @type = ''
  end

  def export
    @logger.debug "Exporting users and groups together ..."
    batch_size = 5000
    # batch_size = 30
    filecount =
    count = 0
    outfile_ticket = nil
    outfile_comment = nil
    outfile_user = nil
    outfile_group = nil
    unique_user_list = nil
    unique_group_list = nil
    # leftover_tickets = Array.new [155, 366, 462, 463, 579, 608, 768, 848, 873, 897, 912, 980, 1435, 1479, 1498, 1521, 1734, 1739, 2158, 2190, 2479, 2569, 2833, 2903, 2944, 2975, 3047, 3074, 3490, 3520, 3573, 3625, 3670, 3834, 3844, 3923, 245792, 245834, 245875, 246362, 246446, 246883, 248135, 248172, 248620, 249203, 249824]
    leftover_tickets = Array.new [23922]

        # open files #
        outfile_ticket = File.open("./output_minis/leftover3_Tickets_#{sprintf('%02d',filecount)}.csv", "wb")
        outfile_comment = File.open("./output_minis/leftover3_Ticket_Comments_#{sprintf('%02d',filecount)}.csv", "wb")
        outfile_user = File.open("./output_minis/leftover3_Users_#{sprintf('%02d',filecount)}.csv", "wb")
        outfile_group = File.open("./output_minis/leftover3_Groups_#{sprintf('%02d',filecount)}.csv", "wb")

        outfile_ticket << (["Ticket #", "Subject", "Description", "Creation Date [yyyy-MM-dd HH:mm:ss z]", "Closure Date [yyyy-MM-dd HH:mm:ss z]", "Requester [id]", "Group", "Assignee [id]", "Type", "Status", "Priority", "Tags", "Queue[23779816]", "Emailed To[23683173]", "User IP[23721196]", "WEB agent[23690807]", "Referrer URL[23690817]", "Web cookie[23683183]", "Thread ID[23721206]"]).join(',')
        outfile_ticket << "\n"

        outfile_comment << (["Ticket #", "Ticket Comment #", "Comment", "Creation Date [yyyy-MM-dd HH:mm:ss z]", "Author [id]", "Public"]).join(',')
        outfile_comment << "\n"

        outfile_user << (["id", "Name", "Email", "Password", "Phone", "Role", "Organization", "Tags", "Details", "Notes"]).join(',')
        outfile_user << "\n"

        outfile_group << (["Name", "Agents"]).join(',')
        outfile_group << "\n"

        unique_user_list = Hash.new
        unique_group_list = Hash.new



    ### loop thru all tickets ###
    # begin
    Ticket.find_each do |t|
      # processed = false

      count += 1 # move to top

      # next if count < 250000
      next if !(leftover_tickets.include? t.id)

      # if (count % batch_size == 0)
        # open files #
        # outfile_ticket = File.open("./output_minis/Tickets_#{sprintf('%02d',filecount)}.csv", "wb")
        # outfile_comment = File.open("./output_minis/Ticket_Comments_#{sprintf('%02d',filecount)}.csv", "wb")
        # outfile_user = File.open("./output_minis/Users_#{sprintf('%02d',filecount)}.csv", "wb")
        # outfile_group = File.open("./output_minis/Groups_#{sprintf('%02d',filecount)}.csv", "wb")

        # outfile_ticket << (["Ticket #", "Subject", "Description", "Creation Date [yyyy-MM-dd HH:mm:ss z]", "Closure Date [yyyy-MM-dd HH:mm:ss z]", "Requester [id]", "Group", "Assignee [id]", "Type", "Status", "Priority", "Tags", "Queue[23779816]", "Emailed To[23683173]", "User IP[23721196]", "WEB agent[23690807]", "Referrer URL[23690817]", "Web cookie[23683183]", "Thread ID[23721206]"]).join(',')
        # outfile_ticket << "\n"

        # outfile_comment << (["Ticket #", "Ticket Comment #", "Comment", "Creation Date [yyyy-MM-dd HH:mm:ss z]", "Author [id]", "Public"]).join(',')
        # outfile_comment << "\n"

        # outfile_user << (["id", "Name", "Email", "Password", "Phone", "Role", "Organization", "Tags", "Details", "Notes"]).join(',')
        # outfile_user << "\n"

        # outfile_group << (["Name", "Agents"]).join(',')
        # outfile_group << "\n"

        # unique_user_list = Hash.new
        # unique_group_list = Hash.new
      # end

      # innercount = 0
      # write individual ticket in within batchsize
      # Ticket.offset(count*batch_size).limit(batch_size).each do |t|

      # processed = true
      ticket_type = t.type.gsub 'Ticket::', ''

      ticket_quoted = Array.new
        [t.id, t.subject, t.description, (Formatter::Time.new t.created_at).formatted, (Formatter::Time.new t.closed_at).formatted, t.requester_id, Group.find_by_id(t.group_id).name, t.assignee_id, ticket_type, t.status, t.priority, t.tag, t.queue, t.emailed_to, t.userIP, t.WEbagent, t.ReferrerURL, t.Webcookie, t.ThreadId].each do |element|
        ticket_quoted << (Formatter::Quote.new element).formatted
      end
      outfile_ticket << ticket_quoted.join(',')
      outfile_ticket << "\n"

      group = ::Group.find_by_id t.group_id
      requester = t.requester
      assignee = t.assignee

      unique_user_list [requester.id] = ["#{requester.name}",  "#{requester.email}", "end user"]
      unique_user_list [assignee.id] = ["#{assignee.name}", "#{assignee.email}", "agent"]
      unique_group_list [assignee.name] = group.name

      # write corresponding comment for this ticket
      t.comments.find_each do |c|
        comment_quoted = Array.new
        [c.ticket_id, c.id, c.body, (Formatter::Time.new c.created_at).formatted, c.author_id, c.is_public].each do |element|
          comment_quoted << (Formatter::Quote.new element).formatted
        end
        outfile_comment << comment_quoted.join(',')
        outfile_comment << "\n"

        author = c.author
        author_type = "end user"
        if !author.type.nil?
          unique_group_list [author.name] = group.name
          author_type = "agent"
        end
        unique_user_list [author.id] = ["#{author.name}", "#{author.email}", author_type]
      end
      # innercount += 1
      @logger.debug "Processed #{count} tickets." if count % 500 == 0
      # end # end of processing tickets in within batchsize

      # count += 1 # move to top
      # if (count % batch_size == 0)
        # @logger.debug "Processed #{count} tickets."
        # @logger.info "Created ./output_minis/Tickets_#{sprintf('%02d',filecount)}.csv"
        # @logger.info "Created ./output_minis/Ticket_Comments_#{sprintf('%02d',filecount)}.csv"

        # unique_user_list.each do |key, value|
        #   user_list_quoted = Array.new
        #     [key, value[0], value[1], '', '', value[2], '', '', '', ''].each do |element|
        #     user_list_quoted << (Formatter::Quote.new element).formatted
        #   end
        #   outfile_user << user_list_quoted.join(',')
        #   outfile_user << "\n"
        # end

        # unique_group_list.each do |key, value|
        #   group_list_quoted = Array.new
        #       [value, key].each do |element|
        #     group_list_quoted << (Formatter::Quote.new element).formatted
        #   end
        #   outfile_group << group_list_quoted.join(',')
        #   outfile_group << "\n"
        # end

        # @logger.info "Created ./output_minis/Users_#{sprintf('%02d',filecount)}.csv"
        # @logger.info "Created ./output_minis/Group_#{sprintf('%02d',filecount)}.csv"
        # outfile_ticket.close
        # outfile_comment.close
        # outfile_user.close
        # outfile_group.close
        filecount += 1
      # end

      # break if filecount == 2
    end


        @logger.debug "Processed #{count} tickets."
        @logger.info "Created ./output_minis/leftover3_Tickets_#{sprintf('%02d',filecount)}.csv"
        @logger.info "Created ./output_minis/leftover3_Ticket_Comments_#{sprintf('%02d',filecount)}.csv"

        unique_user_list.each do |key, value|
          user_list_quoted = Array.new
            [key, value[0], value[1], '', '', value[2], '', '', '', ''].each do |element|
            user_list_quoted << (Formatter::Quote.new element).formatted
          end
          outfile_user << user_list_quoted.join(',')
          outfile_user << "\n"
        end

        unique_group_list.each do |key, value|
          group_list_quoted = Array.new
              [value, key].each do |element|
            group_list_quoted << (Formatter::Quote.new element).formatted
          end
          outfile_group << group_list_quoted.join(',')
          outfile_group << "\n"
        end

        @logger.info "Created ./output_minis/leftover3_Users_#{sprintf('%02d',filecount)}.csv"
        @logger.info "Created ./output_minis/leftover3_Group_#{sprintf('%02d',filecount)}.csv"
        outfile_ticket.close
        outfile_comment.close
        outfile_user.close
        outfile_group.close

      # break if count == 10

    # end while processed
    # @logger.info "Processed ticketss and created two files"
  end
end