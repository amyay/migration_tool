class AddShortnameToUsers < ActiveRecord::Migration
  def change
    add_column :users, :shortname, :string

    User.find_each do |u|
      shortname = Formatter::Shortname.new u.name
      u.shortname = shortname.formatted
      u.save
    end
  end
end