class Formatter::Time < Formatter
  def formatted
    return '' if @raw_string.nil?
    # Time.parse(self).strftime("%m/%d/%Y %T")
    # Time.parse(self).strftime("%Y-%m-%d %T GMT-08:00")
    # for muscogee
    # Time.strptime(self,"%m/%d/%Y %H:%M:%S %p").strftime("%Y-%m-%d %T GMT-05:00")
    # Time.strptime(self,"%m/%d/%y %H:%M").strftime("%Y-%m-%d %T GMT-05:00")
    # Time.strptime(self,"%Y-%m-%d %H:%M:%S").strftime("%Y-%m-%d %T GMT-05:00")
    Time.strptime(@raw_string,"%m/%d/%y %H:%M").strftime("%Y-%m-%d %T GMT-05:00")
  end
end