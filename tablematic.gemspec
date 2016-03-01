$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "tablematic/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "tablematic"
  s.version     = Tablematic::VERSION
  s.authors     = ["Mike Desjardins"]
  s.email       = ["mike.desjardins@cereslogic.com"]
  s.homepage    = "http://www.github.com/mdesjardins/tablematic"
  s.summary     = "Generates tables from AR collections."
  s.description = "Generates tables from AR collections."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]

  s.add_dependency "rails", "~> 4.2.0"

  s.add_development_dependency "sqlite3"
  s.add_development_dependency "rspec-rails"
  s.add_development_dependency "database_cleaner"
  s.add_development_dependency "with_model"
end
