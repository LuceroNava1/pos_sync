# -*- encoding: utf-8 -*-
# stub: bigcommerce 1.0.1 ruby lib

Gem::Specification.new do |s|
  s.name = "bigcommerce".freeze
  s.version = "1.0.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["BigCommerce Engineering".freeze]
  s.date = "2017-12-20"
  s.description = "Ruby client library for the BigCommerce API".freeze
  s.homepage = "https://github.com/bigcommerce/bigcommerce-api-ruby".freeze
  s.licenses = ["MIT".freeze]
  s.required_ruby_version = Gem::Requirement.new(">= 2.0.0".freeze)
  s.rubygems_version = "3.0.6".freeze
  s.summary = "Ruby client library for the BigCommerce API".freeze

  s.installed_by_version = "3.0.6" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<bundler>.freeze, [">= 0"])
      s.add_development_dependency(%q<rake>.freeze, [">= 0"])
      s.add_runtime_dependency(%q<faraday>.freeze, ["~> 0.11"])
      s.add_runtime_dependency(%q<faraday_middleware>.freeze, ["~> 0.11"])
      s.add_runtime_dependency(%q<hashie>.freeze, ["~> 3.4"])
      s.add_runtime_dependency(%q<jwt>.freeze, ["~> 1.5.4"])
    else
      s.add_dependency(%q<bundler>.freeze, [">= 0"])
      s.add_dependency(%q<rake>.freeze, [">= 0"])
      s.add_dependency(%q<faraday>.freeze, ["~> 0.11"])
      s.add_dependency(%q<faraday_middleware>.freeze, ["~> 0.11"])
      s.add_dependency(%q<hashie>.freeze, ["~> 3.4"])
      s.add_dependency(%q<jwt>.freeze, ["~> 1.5.4"])
    end
  else
    s.add_dependency(%q<bundler>.freeze, [">= 0"])
    s.add_dependency(%q<rake>.freeze, [">= 0"])
    s.add_dependency(%q<faraday>.freeze, ["~> 0.11"])
    s.add_dependency(%q<faraday_middleware>.freeze, ["~> 0.11"])
    s.add_dependency(%q<hashie>.freeze, ["~> 3.4"])
    s.add_dependency(%q<jwt>.freeze, ["~> 1.5.4"])
  end
end
