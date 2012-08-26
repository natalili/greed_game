# -*- encoding: utf-8 -*-
require File.expand_path('../lib/greed_game/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["natalili"]
  gem.email         = ["natali.li@list.ru"]
  gem.description   = %q{Greed is a dice game played among 2 or more players, using 5 six-sided dice.}
  gem.summary       = %q{Greed is a dice game}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "greed_game"
  gem.require_paths = ["lib"]
  gem.version       = GreedGame::VERSION

  gem.add_development_dependency "rspec"
end
