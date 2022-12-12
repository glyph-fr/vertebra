$:.push File.expand_path('lib', __dir__)

# Maintain your gem's version:
require 'vertebra/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'vertebra'
  s.version     = Vertebra::VERSION
  s.authors     = ['vala']
  s.email       = ['vala@glyph.fr']
  s.homepage    = 'https://github.com/glyph-fr/vertebra'
  s.summary     = 'Mico-JS Framework based on the Backbone.View API'
  s.description = 'Mico-JS Framework based on the Backbone.View API'
  s.license     = 'MIT'

  s.files = Dir['{app,config,db,lib}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.md']

  s.add_dependency 'rails', '>= 3.1', '<= 8.0'
end
