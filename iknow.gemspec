# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{iknow}
  s.version = "0.1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["nov"]
  s.date = %q{2008-12-19}
  s.description = %q{A rubygem for iKnow! APIs}
  s.email = %q{developer@iknow.co.jp}
  s.extra_rdoc_files = ["README", "ChangeLog"]
  s.files = ["README", "ChangeLog", "Rakefile", "test/iknow_test.rb", "test/test_helper.rb", "lib/ext", "lib/ext/hash.rb", "lib/iknow", "lib/iknow/core", "lib/iknow/core/auth.rb", "lib/iknow/core/config.rb", "lib/iknow/core/version.rb", "lib/iknow/core.rb", "lib/iknow/model", "lib/iknow/model/base.rb", "lib/iknow/model/item.rb", "lib/iknow/model/list.rb", "lib/iknow/model/sentence.rb", "lib/iknow/model/user.rb", "lib/iknow/model.rb", "lib/iknow/rest_client", "lib/iknow/rest_client/base.rb", "lib/iknow/rest_client/item.rb", "lib/iknow/rest_client/list.rb", "lib/iknow/rest_client/sentence.rb", "lib/iknow/rest_client/user.rb", "lib/iknow/rest_client.rb", "lib/iknow.rb", "examples/pure_ruby.rb"]
  s.has_rdoc = true
  s.homepage = %q{http://iknow.rubyforge.org}
  s.rdoc_options = ["--title", "iknow documentation", "--charset", "utf-8", "--opname", "index.html", "--line-numbers", "--main", "README", "--inline-source", "--exclude", "^(examples|extras)/"]
  s.require_paths = ["lib"]
  s.required_ruby_version = Gem::Requirement.new(">= 1.8.6")
  s.rubyforge_project = %q{iknow}
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{A rubygem for iKnow! APIs}
  s.test_files = ["test/iknow_test.rb"]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<rails>, [">= 2.1.0"])
      s.add_runtime_dependency(%q<json>, [">= 0"])
      s.add_runtime_dependency(%q<mechanize>, [">= 0"])
      s.add_runtime_dependency(%q<oauth>, [">= 0.2.7"])
    else
      s.add_dependency(%q<rails>, [">= 2.1.0"])
      s.add_dependency(%q<json>, [">= 0"])
      s.add_dependency(%q<mechanize>, [">= 0"])
      s.add_dependency(%q<oauth>, [">= 0.2.7"])
    end
  else
    s.add_dependency(%q<rails>, [">= 2.1.0"])
    s.add_dependency(%q<json>, [">= 0"])
    s.add_dependency(%q<mechanize>, [">= 0"])
    s.add_dependency(%q<oauth>, [">= 0.2.7"])
  end
end
