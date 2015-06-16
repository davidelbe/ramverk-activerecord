require 'active_record'
require 'logger'

module Ramverk
  class Configuration
    def activerecord
      @activerecord ||= ActiveRecord::Configuration.new
    end
  end

  module ActiveRecord
    class Configuration
      # Initializes default ActiveRecord configurations.
      #
      # @return [Ramverk::ActiveRecord::Configuration]
      def initialize
        ::ActiveRecord::Base.default_timezone = :utc
        ::ActiveRecord::Base.schema_format = :ruby
        ::ActiveRecord::Base.logger = nil

        @db_dir = 'db'
        @migrations_paths = ['db/migrate']
        @seeds_file = 'db/seeds.rb'
      end

      # Controls the format for dumping the database schema to a file. The
      # options are :ruby (the default) for a database-independent version that
      # depends on migrations, or :sql for a set of
      # (potentially database-dependent) SQL statements.
      #
      # @param new_format [Symbol, NilClass] New format.
      #
      # @return [Symbol]
      def schema_format(new_format = nil)
        ::ActiveRecord::Base.schema_format = new_format if new_format
        ::ActiveRecord::Base.schema_format
      end

      # Connection URL or hash used to establish the connection.
      #
      # @param spec [String, Hash, nil] Connection settings.
      #
      # @return [String, Hash]
      def connection(spec = nil)
        if spec
          # We're dealing with a database.yml file
          if spec.is_a?(::String) && spec[0] == '/'
            require 'yaml'
            require 'erb'
            spec = ::YAML.load(::ERB.new(::File.read(spec)).result) || {}
          end

          # Database hash settings
          if spec.is_a?(Hash) && spec[Ramverk.env.to_s]
            ::ActiveRecord::Base.configurations = spec.stringify_keys
            ::ActiveRecord::Base.establish_connection(Ramverk.env)
          # Database URL
          else
            ::ActiveRecord::Base.establish_connection(spec)
            ::ActiveRecord::Base.configurations = {
              Ramverk.env.to_s => ::ActiveRecord::Base.connection.pool.spec.config
            }
          end
        end
      end

      # Default timezone for the database (defaults to `:utc`).
      #
      # @param timezone [Symbol, String] Default timezone.
      #
      # @return [Symbol, String]
      def default_timezone(timezone = nil)
        ::ActiveRecord::Base.default_timezone = timezone if timezone
        ::ActiveRecord::Base.default_timezone
      end

      # Logger used by ActiveRecord to log queries. In development environment a
      # `stdout` logger is enabled b default.
      #
      # @example Add a logger
      #   config.activerecord.logger MyCustomLogger
      #
      # @example Disable logger
      #   config.activerecord.logger nil
      #
      # @return [Array]
      def logger(new_logger = nil)
        ::ActiveRecord::Base.logger = new_logger if new_logger
        ::ActiveRecord::Base.logger
      end

      # Path to where migration files is located. It defaults to `db/migrate`
      # and is relative to your project root.
      #
      # @param path [String, nil] Path to migrations.
      #
      # @return [String]
      def migrations_paths(path = nil)
        @migrations_paths = path if path
        @migrations_paths
      end

      # Path to where the seed file is located.
      #
      # @param file [String, nil] Path and file name.
      #
      # @return [String]
      def seeds_file(file = nil)
        @seeds_file = file if file
        @seeds_file
      end

      def db_dir(dir = nil)
        @db_dir = dir if dir
        @db_dir
      end
    end

    def self.app
      @@app
    end

    def self.included(app)
      @@app = app
      ::ActiveRecord::Base.raise_in_transactional_callbacks = true
      app.use ::ActiveRecord::ConnectionAdapters::ConnectionManagement
    end
  end
end
