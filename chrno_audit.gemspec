# encoding: utf-8
$:.push File.expand_path( "../lib", __FILE__ )
require "chrno_audit/version"

Gem::Specification.new do |s|
  s.name     = "chrno_audit"
  s.version  = ChrnoAudit::VERSION
  s.authors  = [ "Denis Diachkov" ]
  s.email    = [ "d.diachkov@gmail.com" ]
  s.homepage = "https://github.com/ddiachkov/chrno_audit"
  s.summary  = "Simple ActiveRecord audit system"

  s.files         = Dir[ "*", "app/**/*", "lib/**/*" ]
  s.require_paths = [ "lib" ]

  s.required_ruby_version = ">= 1.9.3"

  s.add_runtime_dependency "rails", ">= 3.1"
  s.add_runtime_dependency "activerecord", ">= 3.1"
end