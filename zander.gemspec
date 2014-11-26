lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)

require 'zander/version'

readme = File.open("README.md","rb").read
Gem::Specification.new do |s|
  s.name        	= 'zander'
  s.version     	= Zander::VERSION
  s.date			    = '2014-11-13'
  s.licenses    	= [File.read('LICENSE')]
  s.summary     	= "Streamline Selenium WebDriver Testing with Zander"
  s.description 	= readme[((readme.index("-\n"))+2)...readme.index("\n\n")]
  s.authors     	= ["Spencer Carlson"]
  s.email       	= 'spencerdcarlson@gmail.com'
  s.files       	= `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  s.executables 	= %w(zander)
  s.homepage    	= 'https://github.com/spencerdcarlson/zander'
  s.require_paths 	= %w(lib)
end