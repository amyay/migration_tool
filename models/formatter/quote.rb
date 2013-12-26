class Formatter::Quote < Formatter
  def formatted
    "\"#{escaped}\""
  end

  def escaped
    @raw_string.gsub '"', '\"'
  end
end