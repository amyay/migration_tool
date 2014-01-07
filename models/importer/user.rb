require 'csv'

class Importer::User < Importer
  def initialize csv
    super csv
    @type = 'user'
    @attribute_to_column_name = {
      email: "Email Address",
      name: "Full Name",
      phone: "Phone",
      role: "Role"
    }

  end

  def column_name attribute
    @attribute_to_column_name attribute
  end

  def import_row row
    email = Formatter::Email.new column_name(:email)
    name = Formatter::Name.new column_name(:name)
    phone = Formatter::Phone.new column_name(:phone)

    user_class = role_to_user_class column_name(:role)
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