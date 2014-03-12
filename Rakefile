# http://exposinggotchas.blogspot.hk/2011/02/activerecord-migrations-without-rails.html
require 'yaml'
require 'logger'
require 'active_record'
require 'irb'

namespace :db do
  def create_database config
    options = {:charset => 'utf8', :collation => 'utf8_unicode_ci'}

    ActiveRecord::Base.establish_connection config.merge('database' => nil)
    ActiveRecord::Base.connection.create_database config['database'], options
    ActiveRecord::Base.establish_connection config
    ActiveRecord::Base.default_timezone = 'Eastern Time (US & Canada)'
  end

  task :environment do
    DATABASE_ENV = ENV['DATABASE_ENV'] || 'development'
    MIGRATIONS_DIR = ENV['MIGRATIONS_DIR'] || 'db/migrate'
  end

  task :configuration => :environment do
    @config = YAML.load_file('config/database.yml')[DATABASE_ENV]
  end

  task :configure_connection => :configuration do
    ActiveRecord::Base.establish_connection @config
    ActiveRecord::Base.logger = Logger.new STDOUT if @config['logger']
  end

  desc 'Create the database from config/database.yml for the current DATABASE_ENV'
  task :create => :configure_connection do
    create_database @config
  end

  desc 'Drops the database for the current DATABASE_ENV'
  task :drop => :configure_connection do
    ActiveRecord::Base.connection.drop_database @config['database']
  end

  desc 'Migrate the database (options: VERSION=x, VERBOSE=false).'
  task :migrate => [:configure_connection, :load_models] do
    ActiveRecord::Migration.verbose = true
    ActiveRecord::Migrator.migrate MIGRATIONS_DIR, ENV['VERSION'] ? ENV['VERSION'].to_i : nil
  end

  desc 'Rolls the schema back to the previous version (specify steps w/ STEP=n).'
  task :rollback => [:configure_connection, :load_models] do
    step = ENV['STEP'] ? ENV['STEP'].to_i : 1
    ActiveRecord::Migrator.rollback MIGRATIONS_DIR, step
  end

  desc "Retrieves the current schema version number"
  task :version => :configure_connection do
    puts "Current version: #{ActiveRecord::Migrator.current_version}"
  end
end

task :load_models => "db:configure_connection" do
  Dir["./models/*.rb"].each {|file| require file}
  Dir["./models/ticket/*.rb"].each {|file| require file}
  Dir["./models/user/*.rb"].each {|file| require file}
  Dir["./models/importer/*.rb"].each {|file| require file}
  Dir["./models/exporter/*.rb"].each {|file| require file}
  Dir["./models/formatter/*.rb"].each {|file| require file}
end

namespace :import do
  desc 'Importing users...'
  task :users, [:csv] => :load_models do |t, args|
    importer = Importer::User.new args.csv
    importer.import
  end

  task :agents, [:csv] => :load_models do |t, args|
    importer = Importer::Agent.new args.csv
    importer.import
  end

  task :tickets, [:csv] => :load_models do |t, args|
    importer = Importer::Ticket.new args.csv
    importer.import
  end

  task :comments, [:csv] => :load_models do |t, args|
    importer = Importer::Comment.new args.csv
    importer.import
  end
end

namespace :export do
  task :tickets, [:csv] => :load_models do |t, args|
    exporter = Exporter::Ticket.new args.csv
    exporter.export
  end

  task :comments, [:csv] => :load_models do |t, args|
    exporter = Exporter::Comment.new args.csv
    exporter.export
  end

  task :users, [:csv] => :load_models do |t, args|
    exporter = Exporter::User.new args.csv
    exporter.export
  end

  task :group, [:csv] => :load_models do |t, args|
    exporter = Exporter::Group.new args.csv
    exporter.export
  end

  task :organization, [:csv] => :load_models do |t, args|
    exporter = Exporter::Organization.new args.csv
    exporter.export
  end

  task :special => :load_models do |t, args|
    exporter = Special.new args.csv
    exporter.export
  end



end

task :console => :load_models do
  ARGV.clear
  IRB.start
end