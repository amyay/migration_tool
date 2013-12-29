require 'csv'

class Importer::User < Importer
  def initialize csv
    super
    @type = 'user'
  end

  def import_row row
    email = Formatter::Email.new row['Email Address']
    name = Formatter::Name.new row['Full Name']
    phone = Formatter::Phone.new row['Phone']

    user_class = role_to_user_class row['Role']
    user = user_class.find_or_create_by_email email.formatted
    user.name = name.formatted
    user.phone = phone.formatted
    user.save!
  end

private
  def role_to_user_class role
    if role == 'End-User'
      return ::User
    elsif role == 'Staff'
      return ::User::Agent
    else
      raise "Unknown role: #{role}"
    end
  end
end