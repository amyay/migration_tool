class Formatter
  def initialize raw
    @raw_string = raw.to_s
    @logger = Logger.new STDOUT
  end
end