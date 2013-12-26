class Importer
  def initialize csv
    @csv = csv
    @logger = Logger.new STDOUT
  end
end