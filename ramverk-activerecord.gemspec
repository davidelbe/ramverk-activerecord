require_relative './lib/ramverk/activerecord/version'

Gem::Specification.new do |spec|
  spec.name          = 'ramverk-activerecord'
  spec.version       = Ramverk::ActiveRecord::VERSION
  spec.authors       = ['Tobias Sandelius']
  spec.email         = ['tobias@sandeli.us']
  spec.summary       = %q{Ramverk with ActiveRecord.}
  spec.homepage      = 'https://github.com/sandelius/ramverk-activerecord'
  spec.license       = 'MIT'
  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']
  spec.required_ruby_version = '>= 2.2.0'

  spec.add_runtime_dependency 'activerecord', '~> 4.2'

  spec.add_development_dependency 'ramverk'
  spec.add_development_dependency 'sqlite3'
  spec.add_development_dependency 'bundler',   '~> 1.6'
  spec.add_development_dependency 'rake',      '~> 10'
  spec.add_development_dependency 'minitest',  '~> 5'
  spec.add_development_dependency 'simplecov'
  spec.add_development_dependency 'coveralls'
end
