$LOAD_PATH.push File.expand_path("../lib", __FILE__)



Gem::Specification.new do |s|
  s.name        = 'rtrain'
  s.version     = '0.2.3'
  s.date        = '2016-05-31'
  s.summary     = "Nicer Scaffolds,nav bar, static homepage for Rails"
  s.description = "Rails UI Booster - More info @ https://github.com/lynnd335/rtrain"
  s.authors     = ["Dan Lynn"]
  s.email       = 'lynnd335@gmail.com'
  s.files       =  Dir['**/*']
  s.homepage    = 'http://rubygems.org/gems/rtrain'
  s.license     = 'MIT'
  s.add_runtime_dependency 'authlogic', '~> 3.4', '>= 3.4.6'
end
