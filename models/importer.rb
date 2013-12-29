class Importer
  def initialize csv
    @csv = csv
    @logger = Logger.new STDOUT
    @type = ''
  end

  def import
    @logger.debug "Importing #{@type}s from #{@csv}"
    count = 0
    CSV.foreach(@csv, :headers=>true) do |row|
      import_row row
      count += 1
      @logger.debug "Processed #{count} #{@type}s." if count % 500 == 0
    end
    @logger.info "Processed #{count} #{@type}s from #{@csv}"
  end
end