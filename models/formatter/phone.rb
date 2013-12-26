class Formatter::Phone < Formatter
  def formatted
    return @raw_string if @raw_string.nil?
    @raw_string.gsub /[\t]/, ''
  end
end