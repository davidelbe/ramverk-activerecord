# Ramverk with Sequel

### Usage
```ruby
# Gemfile
gem 'ramverk-activerecord'
gem 'pg' # or 'mysql2' or 'sqlite3' or ...
```

```ruby
# config/application.rb
require 'ramverk/activerecord'

class Application < Ramverk::Application
  include Ramverk::ActiveRecord

  config.activerecord.connection "#{Ramverk.root}/config/database.yml"

  configure :development do
    config.activerecord.logger Logger.new(STDOUT)
  end

  # Other configurations and their defaults
  # config.activerecord.logger nil
  # config.activerecord.schema_format :ruby
  # config.activerecord.default_timezone :utc
  # config.activerecord.migrations_path 'db/migrate'
  # config.activerecord.seeds_file 'db/seeds.rb'
  # config.activerecord.db_dir 'db'
end
```

```ruby
# Rakefile
require 'ramverk/activerecord/rake' # After main application file
```

### Rake

```bash
bundle exec rake -T

db:create   # Create the database in the current environment
db:drop     # Drop the database in the current environment
db:generate # Create a migration (required: NAME, optional: VERSION)
db:migrate  # Run pending migrations (optional: STEP)
db:rollback # Perform rollback (optional: STEP)
db:seed     # Load seeds file
```
