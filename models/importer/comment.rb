require 'csv'

class Importer::Comment < Importer
  def initialize csv
    super csv
    @type = 'comment'
  end

  def import_row row
    # first, make sure comment matches a valid ticket
    ticket = ::Ticket.find_by_legacy_id row['Ticket#']
    if ticket.nil?
      # related ticket can't be found
      puts "did not import comnent ID " + row['TicketComment']
      return
    end

    ## look for author ##
    author = nil
    author_class = public_to_user_class row['Public']

    if row['Author'].include? '@'
      author_email = (Formatter::Email.new row['Author']).formatted
      # author = ::User.find_or_create_by_email author_email
      author = author_class.find_or_create_by_email author_email
    else
      # author doesn't contain email address
      # check if there's anything there
      if !(row['Author'].nil? || row['Author'].empty?)
        # author contains something
        # try searching by name
        # author = ::User.find_by_name row['Author']
        author = author_class.find_by_name row['Author']
        if author.nil?
          # cannot find author
          # make up author
          address = row['Author'].gsub " ", "."
          domain = "legacyuser-tripadvisor.com"
          made_up_email = "#{address}@#{domain}"

          # depending if public is public or private, create end user or agent
          # author_class = public_to_user_class row['Public']
          author = author_class.find_or_create_by_email made_up_email
          author.name = row['Author']
          author.save!
        end
      end
    end

    ## create comment ##
    comment = ::Comment.new
    comment.author = author
    comment.body = row['Comment']
    comment.is_public = is_it_public row['Public']
    comment.created_at = (Formatter::Time.new row['Creation Date']).formatted
    comment.ticket = ticket
    comment.save!
  end

  def public_to_user_class public_value
    if public_value.downcase == 'false'
      return ::User::Agent
    elsif public_value.downcase == 'true' || public_value.empty? || public_value.nil?
      return ::User
    else
      raise "Unknown comment public type: #{public_value}"
    end
  end

  def is_it_public public_value
    if public_value.downcase == 'false'
      return false
    elsif public_value.downcase == 'true' || public_value.empty? || public_value.nil?
      return true
    else
      raise "Unknown comment public type: #{public_value}"
    end
  end
end
