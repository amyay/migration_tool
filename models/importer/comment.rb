require 'csv'

class Importer::Comment < Importer
  def initialize csv
    super csv
    @type = 'comment'
  end

  def import_row row
    # first, make sure comment matches a valid ticket
    ticket = ::Ticket.find_by_legacy_id row['AR_NUMBER']
    if ticket.nil?
      # related ticket can't be found
      puts "did not import comnent ID " + row['ACT_NUMBER']
      return
    end

    # for medidata: all comments are made by agent and private
    author_shortname = (Formatter::Shortname.new row['ACT_OWNER']).formatted
    author = ::User::Agent.find_by_shortname author_shortname

    if author.nil?
      domain = "legacymedidata.com"
      made_up_email = "#{author_shortname}@#{domain}"
      author = ::User::Agent.find_or_create_by_email made_up_email
      author.name = author_shortname
      author.shortname = author_shortname
      author.save!
    end

    comment = ::Comment.new
    comment.author = author
    comment.body = row['ACT_DESC']
    comment.is_public = false
    comment.created_at = (Formatter::Time.new row['ACT_CREATED']).formatted
    comment.ticket = ticket
    comment.save!
  end
end
