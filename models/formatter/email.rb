class Formatter::Email < Formatter
  def formatted
    begin
      temail = @raw_string.gsub ';', ','
      temail.gsub! /[*<(>)"\s\t]/, ''
      # temail.gsub! /\s/, ''
      temail.split(',')[0].downcase
    rescue
      ""
    end
  end

  def validate!(&block)
    if !valid?
      @logger.debug "Invalid email: #{formatted}, replaced with #{block.call}"
      @raw_string = block.call
    end
  end

  def valid?
    temp = formatted
    !temp.nil? && !temp.empty? && (temp!="blank")
  end
end