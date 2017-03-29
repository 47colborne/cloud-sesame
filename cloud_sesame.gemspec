Gem::Specification.new do |s|
  s.name        = 'CloudSesame'
  s.version     = '1.0.0'
  s.date        = '2017-03-29'
  s.summary     = "AWS CloudSearch Query DSL"
  s.description = "AWS CloudSearch Query DSL"
  s.authors = [
    'Scott Chu',
    'Emily Fan',
    'Greg Ward',
    'David McHoull',
    'Alishan Ladhani',
    'Justine Jones',
    'Gillian Chesnais',
    'Jeff Li',
    'Nick Zhu'
  ]
  s.email = 'dev@retailcommon.com'
  s.homepage = 'https://github.com/47colborne/cloud-sesame'
  s.platform = Gem::Platform::RUBY
  s.license = 'MIT'

  s.files = `git ls-files -z`.split("\x0")
  s.executables = s.files.grep(%r{^bin/}) { |f| File.basename(f) }
  s.test_files = s.files.grep(%r{^(test|spec|features)/})
  s.require_paths = ['lib']

  s.add_dependency 'aws-sdk', '~> 2'

  s.add_development_dependency 'rspec', '~> 3'
  s.add_development_dependency 'pry', '~> 0'
  s.add_development_dependency 'guard'
  s.add_development_dependency 'guard-rspec'
  s.add_development_dependency 'ruby-prof'
  s.add_development_dependency 'guard-rubocop'
end
