class Formatter::Name < Formatter
  def formatted
    return @raw_string if @raw_string.nil?
    @raw_string.strip.gsub /[\t\r\n]/, ''
  end
end