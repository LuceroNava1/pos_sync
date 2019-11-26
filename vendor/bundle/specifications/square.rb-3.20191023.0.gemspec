# -*- encoding: utf-8 -*-
# stub: square.rb 3.20191023.0 ruby lib

Gem::Specification.new do |s|
  s.name = "square.rb".freeze
  s.version = "3.20191023.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Square Developer Platform".freeze]
  s.date = "2019-10-24"
  s.description = "Use Square APIs to manage and run business including payment, customer, product, inventory, and employee management.".freeze
  s.email = "developers@squareup.com".freeze
  s.homepage = "https://squareup.com/developers".freeze
  s.licenses = ["Apache-2.0".freeze]
  s.required_ruby_version = Gem::Requirement.new("~> 2.0".freeze)
  s.rubygems_version = "3.0.6".freeze
  s.summary = "square".freeze

  s.installed_by_version = "3.0.6" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<logging>.freeze, ["~> 2.2"])
      s.add_runtime_dependency(%q<faraday>.freeze, ["~> 0.15"])
      s.add_runtime_dependency(%q<faraday_middleware>.freeze, ["~> 0.13"])
      s.add_runtime_dependency(%q<certifi>.freeze, ["~> 2018.1"])
      s.add_runtime_dependency(%q<faraday-http-cache>.freeze, ["~> 2.0"])
      s.add_development_dependency(%q<minitest>.freeze, ["~> 5.0"])
      s.add_development_dependency(%q<minitest-proveit>.freeze, ["~> 1.0"])
    else
      s.add_dependency(%q<logging>.freeze, ["~> 2.2"])
      s.add_dependency(%q<faraday>.freeze, ["~> 0.15"])
      s.add_dependency(%q<faraday_middleware>.freeze, ["~> 0.13"])
      s.add_dependency(%q<certifi>.freeze, ["~> 2018.1"])
      s.add_dependency(%q<faraday-http-cache>.freeze, ["~> 2.0"])
      s.add_dependency(%q<minitest>.freeze, ["~> 5.0"])
      s.add_dependency(%q<minitest-proveit>.freeze, ["~> 1.0"])
    end
  else
    s.add_dependency(%q<logging>.freeze, ["~> 2.2"])
    s.add_dependency(%q<faraday>.freeze, ["~> 0.15"])
    s.add_dependency(%q<faraday_middleware>.freeze, ["~> 0.13"])
    s.add_dependency(%q<certifi>.freeze, ["~> 2018.1"])
    s.add_dependency(%q<faraday-http-cache>.freeze, ["~> 2.0"])
    s.add_dependency(%q<minitest>.freeze, ["~> 5.0"])
    s.add_dependency(%q<minitest-proveit>.freeze, ["~> 1.0"])
  end
end
