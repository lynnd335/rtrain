$LOAD_PATH.push File.expand_path("../lib", __FILE__)

Gem::Specification.new do |s|
  s.name        = 'rtrain'
  s.version     = '0.1.7'
  s.date        = '2016-04-19'
  s.summary     = "Nicer Scaffolds"
  s.description = "Rails UI Booster - More info @ https://github.com/lynnd335/rtrain"
  s.authors     = ["Dan Lynn"]
  s.email       = 'lynnd335@gmail.com'
  s.files       = ["lib/rtrain.rb",
                   "lib/generators/templates/rtrain_scaffold.scss"]
  s.homepage    = 'http://rubygems.org/gems/rtrain'
  s.license     = 'MIT'
end
