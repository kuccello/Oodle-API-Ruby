Gem::Specification.new do |s|
  s.name = %q{oodle}
  s.version = '1.1.4'
  s.authors = ["Kristan 'Krispy' Uccello", 'Albert Vernon']
  s.email = %q{kaptiankrispy@soldierofcode.com}
  s.summary = %q{Provides a Ruby wrapper around the Oodle API}
  s.homepage = %q{http://github.com/kuccello/Oodle-API-Ruby}
  s.description = %q{Provides a Ruby wrapper around the Oodle API}
  s.files = [ 'README.markdown', 'LICENSE', 'lib/oodle.rb' ]
  s.add_dependency('xml-simple')
  s.add_dependency('json')
  s.test_file = 'test/oodle_tests.rb'
end
