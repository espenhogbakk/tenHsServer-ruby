# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "ten_hs_server/version"

Gem::Specification.new do |s|
  s.name        = "ten_hs_server"
  s.version     = TenHsServer::VERSION
  s.authors     = ["Espen Hogbakk"]
  s.email       = ["espen@hogbakk.no"]
  s.homepage    = ""
  s.summary     = "tenHsServer Homeseer API wrapper."
  s.description = "API wrapper around the (crappy) tenHsServer Homeseer HS2 plugin."

  s.rubyforge_project = "ten_hs_server"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  s.add_development_dependency "activesupport"
  s.add_development_dependency "factory_girl"
  s.add_development_dependency "mocha"
  s.add_development_dependency "webmock"

  s.add_runtime_dependency "httparty"
  s.add_runtime_dependency "nokogiri"
end
