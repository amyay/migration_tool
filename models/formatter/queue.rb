class Formatter::Queue < Formatter
  def formatted
    return @raw_string if @raw_string.nil?
    tqueue = @raw_string.gsub /[()]/, ''
    tqueue.gsub! ' - ', '_'
    tqueue.gsub! ' ', '_'
    tqueue.gsub! '/', '_'
    tqueue.downcase!
    return "legacy_queue_#{tqueue}"
  end
end