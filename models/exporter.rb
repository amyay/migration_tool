class Exporter
  def initialize
    @logger = Logger.new STDOUT
    @type = ''
  end

  def export
    @logger.debug "Exporting #{@type}s ..."
    count = 0
    outfile = File.open("./output/#{@type}.csv", "wb")
    outfile << export_header
    outfile << "\n"
    export_class.find_each do |item|
      outfile << (export_row item)
      outfile << "\n"
      count += 1
      @logger.debug "Processed #{count} #{@type}s." if count % 500 == 0
    end
    @logger.info "Processed #{count} #{@type}s and created ./output/#{@type}.csv"
  end
end