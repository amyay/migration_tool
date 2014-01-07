require 'csv'

class Importer::Agent < Importer
  def initialize csv
    super csv
    @type = 'agent'
    @attribute_to_column_name = {
      email: "Email",
      name: "Name",
      phone: "Phone",
      group: "Group"
    }
  end

  def column_name attribute
    @attribute_to_column_name attribute
  end

  def import_row row
    email = Formatter::Email.new column_name(:email)
    name = Formatter::Name.new column_name(:name)
    phone = Formatter::Phone.new column_name(:phone)
    user = ::User::Agent.find_or_create_by_email email.formatted
    user.name = name.formatted
    user.phone = phone.formatted

    group = ::Group.find_or_create_by_name column_name(:group)
    user.groups << group
    user.save!
  end
end