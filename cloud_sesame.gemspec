Gem::Specification.new do |s|
  s.name        = 'CloudSesame'
  s.version     = '0.1.0'
  s.date        = '2016-01-13'
  s.summary     = "AWS CloudSearch Query Interface"
  s.description = "AWS CloudSearch Query Interface"
  s.authors = ['Scott Chu', 'Emily Fan', 'Greg Ward', 'David McHoull',
    'Alishan Ladhani', 'Justine Jones', 'Gillian Chesnais', 'Jeff Li']
  s.email = 'dev@retailcommon.com'
  s.homepage = 'https://github.com/47colborne/cloud_sesame'
  s.platform = Gem::Platform::RUBY
  s.license = 'MIT'

  s.files = `git ls-files -z`.split("\x0")
  s.executables = s.files.grep(%r{^bin/}) { |f| File.basename(f) }
  s.test_files = s.files.grep(%r{^(test|spec|features)/})
  s.require_paths = ['lib']

  s.add_dependency('aws-sdk', '~> 2')

  s.add_development_dependency 'rspec', '~> 3'
  s.add_development_dependency 'pry', '~> 0'
  s.add_development_dependency 'guard'
  s.add_development_dependency 'guard-rspec'
end