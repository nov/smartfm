Gem::Specification.new do |s|
  s.name = %q{iknow}
  s.version = "0.0.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["nov"]
  s.date = %q{2008-10-15}
  s.description = %q{A rubygem for iKnow! APIs}
  s.email = %q{developer@iknow.co.jp}
  s.extra_rdoc_files = ["README", "ChangeLog"]
  s.files = ["README", "ChangeLog", "Rakefile", "test/iknow_test.rb", "test/test_helper.rb", "lib/ext", "lib/ext/hash.rb", "lib/iknow", "lib/iknow/core", "lib/iknow/core/config.rb", "lib/iknow/core/version.rb", "lib/iknow/core.rb", "lib/iknow/model", "lib/iknow/model/base.rb", "lib/iknow/model/item.rb", "lib/iknow/model/list.rb", "lib/iknow/model/sentence.rb", "lib/iknow/model/user.rb", "lib/iknow/model.rb", "lib/iknow/rest_client", "lib/iknow/rest_client/base.rb", "lib/iknow/rest_client/item.rb", "lib/iknow/rest_client/list.rb", "lib/iknow/rest_client/sentence.rb", "lib/iknow/rest_client/user.rb", "lib/iknow/rest_client.rb", "lib/iknow.rb"]
  s.has_rdoc = true
  s.homepage = %q{http://iknow.rubyforge.org}
  s.rdoc_options = ["--title", "iknow documentation", "--charset", "utf-8", "--opname", "index.html", "--line-numbers", "--main", "README", "--inline-source", "--exclude", "^(examples|extras)/"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{iknow}
  s.rubygems_version = %q{1.2.0}
  s.summary = %q{A rubygem for iKnow! APIs}
  s.test_files = ["test/iknow_test.rb"]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if current_version >= 3 then
      s.add_runtime_dependency(%q<json>, [">= 0"])
    else
      s.add_dependency(%q<json>, [">= 0"])
    end
  else
    s.add_dependency(%q<json>, [">= 0"])
  end
end
