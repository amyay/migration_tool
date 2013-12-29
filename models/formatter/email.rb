class Formatter::Email < Formatter
  def formatted
    if @raw_string.downcase == '(blank)'
      return @raw_string.downcase
    end
    temail = @raw_string.gsub ';', ','
    temail.gsub! /[*<(>)"\s\t]/, ''
    # temail.gsub! /\s/, ''
    temail.split(',')[0].downcase
  end
end