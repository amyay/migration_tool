require 'csv'

class Importer::User < Importer
  def import
    @logger.debug "Importing users from #{@csv}"
    count = 0
    CSV.foreach(@csv, :headers=>true) do |row|
      user_class = self.class.role_to_user_class row['Role']
      user = user_class.find_or_create_by_email row['Email Address']
      user.name = row['Full Name']
      user.phone = row['Phone']
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