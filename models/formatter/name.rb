class Formatter::Name < Formatter
  def formatted
    return @raw_string if @raw_string.nil?
    @raw_string.gsub /[\s\t\r\n]/, ''
  end
end