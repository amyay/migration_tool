class Formatter::Shortname < Formatter
  def formatted # remove all spaces and tabs and downcased
    return @raw_string if @raw_string.nil?
    (@raw_string.gsub /[\s\t\r\n]/, '').downcase
  end
end