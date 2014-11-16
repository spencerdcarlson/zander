lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)

require 'zander/version'

Gem::Specification.new do |s|
  s.name        	= 'zander'
  s.version     	= Zander::VERSION
  s.date			= '2014-11-13'
  s.licenses    	= ['MIT']
  s.summary     	= "Simple Web Automation"
  s.description 	= "Zabner will help automate web testing using Selenium::WebDriver"
  s.authors     	= ["Spencer Carlson"]
  s.email       	= 'spencerdcarlson@gmail.com'
  s.files       	= `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  s.executables 	<< 'zander'
  s.homepage    	= ''
  s.require_paths 	= %w(lib)
end