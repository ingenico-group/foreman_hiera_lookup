require File.expand_path('../lib/foreman_hiera_lookup/version', __FILE__)


Gem::Specification.new do |s|
  s.name        = 'foreman_hiera_lookup'
  s.version     = ForemanHieraLookup::VERSION
  s.date        = "2015-07-03"
  s.authors     = ['Nagarjuna Rachaneni']
  s.email       = ['nn.nagarjuna@gmail.com']
  s.homepage    = 'https://github.com/ingenico-group/foreman_expire_hosts/commits/master'
  s.summary     = 'Show value of given hiera variable for a specific host'
  # also update locale/gemspec.rb
  s.description = 'Together with value we can show also dependencies of variable and the path of yaml'

  s.files = Dir['{app,config,lib,locale}/**/*'] + ['LICENSE', 'Rakefile', 'README.md']
  s.test_files = Dir['test/**/*']

  s.add_dependency 'deface'
end
