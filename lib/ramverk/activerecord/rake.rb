load 'active_record/railties/databases.rake'

ActiveRecord::Tasks::DatabaseTasks.tap do |config|
  config.root = Rake.application.original_dir
  config.env = Ramverk.env.to_s
  config.db_dir = Ramverk::ActiveRecord.app.config.activerecord.db_dir
  config.migrations_paths = Array(Ramverk::ActiveRecord.app.config.activerecord.migrations_paths)
  config.database_configuration = ActiveRecord::Base.configurations
  config.seed_loader = Class.new do
    def load_seed
      root = ActiveRecord::Tasks::DatabaseTasks.root
      file = Ramverk::ActiveRecord.app.config.activerecord.seeds_file
      load "#{root}/#{file}"
    end
  end.new
end

# db:load_config can be overriden manually
Rake::Task['db:seed'].enhance(['db:load_config'])
Rake::Task['db:load_config'].clear

# define Rails' tasks as no-op
Rake::Task.define_task('db:environment')

require 'active_support/core_ext/string/strip'
require 'pathname'
require 'fileutils'

namespace :db do
  desc "Create a migration (parameters: NAME, VERSION)"
  task :generate do
    unless ENV["NAME"]
      puts "No NAME specified. Example usage: `rake db:create_migration NAME=create_users`"
      exit
    end

    name    = ENV["NAME"]
    version = ENV["VERSION"] || Time.now.utc.strftime("%Y%m%d%H%M%S")

    ActiveRecord::Migrator.migrations_paths.each do |directory|
      next unless File.exist?(directory)
      migration_files = Pathname(directory).children
      if duplicate = migration_files.find { |path| path.basename.to_s.include?(name) }
        puts "Another migration is already named \"#{name}\": #{duplicate}."
        exit
      end
    end

    filename = "#{version}_#{name}.rb"
    dirname  = ActiveRecord::Migrator.migrations_path
    path     = File.join(dirname, filename)

    FileUtils.mkdir_p(dirname)
    File.write path, <<-MIGRATION.strip_heredoc
      class #{name.camelize} < ActiveRecord::Migration
        def change
        end
      end
    MIGRATION

    puts path
  end
end