# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{integritray}
  s.version = "0.1.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Josh French"]
  s.date = %q{2009-07-08}
  s.email = %q{josh@digitalpulp.com}
  s.extra_rdoc_files = [
    "LICENSE",
     "README.rdoc"
  ]
  s.files = [
    ".document",
     ".gitignore",
     "LICENSE",
     "README.rdoc",
     "Rakefile",
     "VERSION",
     "integritray.gemspec",
     "lib/integrity/integritray.rb",
     "test/acceptance/acceptance_helper.rb",
     "test/acceptance/integritray_test.rb"
  ]
  s.homepage = %q{http://github.com/jfrench/integritray}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.4}
  s.summary = %q{CCMenu support for Integrity}
  s.test_files = [
    "test/acceptance/acceptance_helper.rb",
     "test/acceptance/integritray_test.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
