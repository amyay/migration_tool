class Formatter::Quote < Formatter
  def formatted
    "\"#{escaped}\""
  end

  def escaped
    if @raw_string.nil?
      return ''
    end
    @raw_string.gsub '"', '\"'
  end
end