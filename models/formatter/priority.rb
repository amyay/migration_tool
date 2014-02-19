class Formatter::Priority < Formatter
  def formatted
    return @raw_string if @raw_string.nil?
    case @raw_string.downcase
    when 'medium'
      return 'normal'
    when 'cirt'
      return 'urgent'
    else
      return @raw_string.downcase
    end
  end
end