$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "rails_appcache/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "rails_appcache"
  s.version     = RailsAppcache::VERSION
  s.authors     = ["Matthew Eagar"]
  s.email       = ["me@meagar.net"]
  s.homepage    = "http://github.com/meagar/rails_appcache"
  s.summary     = "Simple appcache helpers for Rails"
  s.description = "Simple appcache helpers for Rails"
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 4.2.0"
end
