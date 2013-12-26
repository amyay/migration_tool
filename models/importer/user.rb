require 'csv'

class Importer::User < Importer
  def import
    @logger.debug "Importing users from #{@csv}"
    count = 0
    CSV.foreach(@csv, :headers=>true) do |row|
      email = Formatter::Email.new row['Email Address']
      name = Formatter::Name.new row['Full Name']
      phone = Formatter::Phone.new row['Phone']

      user_class = self.class.role_to_user_class row['Role']
      user = user_class.find_or_create_by_email email.to_s
      user.name = name.to_s
      user.phone = phone.to_s
      user.save!

      count += 1
      @logger.debug "Processed #{count} users." if count % 500 == 0
    end
    @logger.info "Processed #{count} users from #{@csv}"
  end

  def self.role_to_user_class role
    if role == 'End-User'
      return ::User
    elsif role == 'Staff'
      return ::User::Agent
    else
      raise "Unknown role: #{role}"
    end
  end
end