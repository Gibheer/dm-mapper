source :rubygems

gemspec

gem 'dm-mapper', :path => '.'

gem 'inflector',             :github => 'mbj/inflector'
gem 'veritas',               :github => 'dkubb/veritas'
gem 'veritas-sql-generator', :github => 'dkubb/veritas-sql-generator'
gem 'veritas-do-adapter',    :github => 'dkubb/veritas-do-adapter'
gem 'virtus'

group :arel_engine do
  gem 'activerecord'
  gem 'arel', :github => 'rails/arel'
  gem 'pg', :platforms => :ruby

  platforms :jruby do
    gem 'activerecord-jdbcpostgresql-adapter', '>= 1.2.0'
  end
end

group :test do
  gem 'backports'
  gem 'do_postgres'
  gem 'randexp'
  gem 'ruby-graphviz'
end

group :development do
  gem 'devtools', :github => 'datamapper/devtools'
  gem 'mutant-melbourne'
  eval File.read('Gemfile.devtools')
end
