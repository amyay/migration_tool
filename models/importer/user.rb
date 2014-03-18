require 'csv'

class Importer::User < Importer
  def initialize csv
    super csv
    @type = 'user'
  end

  def import_row row
    email = Formatter::Email.new row['Email']
    name = Formatter::Name.new row['Full Name']

    email.validate! do
      address = name.formatted.gsub " ", "."
      domain = "legacyuser-tripadvisor.com"
      made_up_address = "#{address}@#{domain}"
    end

    user_class = role_to_user_class row['Role']
    user = user_class.find_or_create_by_email email.formatted
    # user = ::User.find_or_create_by_email email.formatted
    user.name = name.formatted
    user.save!
  end

private
  def role_to_user_class role
    if role == 'end user'
      return ::User
    elsif role == 'agent'
      return ::User::Agent
    else
      raise "Unknown role: #{role}"
    end
  end
end