# -*- encoding: utf-8 -*-
# stub: certifi 2018.01.18 ruby lib

Gem::Specification.new do |s|
  s.name = "certifi".freeze
  s.version = "2018.01.18"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Kenneth Reitz".freeze, "Terence Lee".freeze]
  s.date = "2018-01-18"
  s.description = "Rubygem for providing Mozilla's CA Bundle".freeze
  s.email = ["me@kennethreitz.org".freeze, "hone02@gmail.com".freeze]
  s.homepage = "http://certifi.io/".freeze
  s.licenses = ["MPL2.0".freeze]
  s.rubygems_version = "3.0.6".freeze
  s.summary = "Rubygem for providing Mozilla's CA Bundle".freeze

  s.installed_by_version = "3.0.6" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<bundler>.freeze, ["~> 1.6"])
      s.add_development_dependency(%q<rake>.freeze, [">= 0"])
      s.add_development_dependency(%q<rspec-core>.freeze, [">= 0"])
      s.add_development_dependency(%q<rspec-expectations>.freeze, [">= 0"])
    else
      s.add_dependency(%q<bundler>.freeze, ["~> 1.6"])
      s.add_dependency(%q<rake>.freeze, [">= 0"])
      s.add_dependency(%q<rspec-core>.freeze, [">= 0"])
      s.add_dependency(%q<rspec-expectations>.freeze, [">= 0"])
    end
  else
    s.add_dependency(%q<bundler>.freeze, ["~> 1.6"])
    s.add_dependency(%q<rake>.freeze, [">= 0"])
    s.add_dependency(%q<rspec-core>.freeze, [">= 0"])
    s.add_dependency(%q<rspec-expectations>.freeze, [">= 0"])
  end
end
