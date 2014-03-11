require 'time'

class Formatter::Time < Formatter
  def formatted
    return '' if @raw_string.nil?
    # Time.parse(self).strftime("%m/%d/%Y %T")
    # Time.parse(self).strftime("%Y-%m-%d %T GMT-08:00")
    # for muscogee
    # ::Time.strptime(@raw_string,"%m/%d/%Y %H:%M:%S %p").strftime("%Y-%m-%d %T GMT-05:00")
    # ::Time.strptime(@raw_string,"%m/%d/%y %H:%M").strftime("%Y-%m-%d %T GMT-05:00")
    ::Time.strptime(@raw_string,"%Y-%m-%d %H:%M:%S").strftime("%Y-%m-%d %T GMT-05:00")
    # ::Time.strptime(@raw_string,"%m/%d/%y %H:%M").strftime("%Y-%m-%d %T GMT-05:00")
    # ::Time.strptime(@raw_string,"%m/%d/%y").strftime("%Y-%m-%d")
  end
end