# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{smartfm}
  s.version = "1.0.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["nov"]
  s.date = %q{2009-05-01}
  s.description = %q{A rubygem for smart.fm APIs}
  s.email = %q{developer@smart.fm}
  s.extra_rdoc_files = ["README", "ChangeLog"]
  s.files = ["README", "ChangeLog", "Rakefile", "test/smartfm_test.rb", "test/test_helper.rb", "spec/ext", "spec/ext/hash_spec.rb", "spec/smartfm", "spec/smartfm/core", "spec/smartfm/core/auth_spec.rb", "spec/smartfm/core/config_spec.rb", "spec/smartfm/core/version_spec.rb", "spec/smartfm/models", "spec/smartfm/models/base_spec.rb", "spec/smartfm/models/item_spec.rb", "spec/smartfm/models/like_spec.rb", "spec/smartfm/models/list_spec.rb", "spec/smartfm/models/notification_spec.rb", "spec/smartfm/models/sentence_spec.rb", "spec/smartfm/models/user_spec.rb", "spec/smartfm/rest_clients", "spec/smartfm/rest_clients/base_spec.rb", "spec/smartfm/rest_clients/item_spec.rb", "spec/smartfm/rest_clients/like_spec.rb", "spec/smartfm/rest_clients/list_spec.rb", "spec/smartfm/rest_clients/notification_spec.rb", "spec/smartfm/rest_clients/sentence_spec.rb", "spec/smartfm/rest_clients/user_spec.rb", "spec/spec_helper.rb", "lib/ext", "lib/ext/hash.rb", "lib/smartfm", "lib/smartfm/core", "lib/smartfm/core/auth.rb", "lib/smartfm/core/config.rb", "lib/smartfm/core/version.rb", "lib/smartfm/core.rb", "lib/smartfm/models", "lib/smartfm/models/base.rb", "lib/smartfm/models/item.rb", "lib/smartfm/models/like.rb", "lib/smartfm/models/list.rb", "lib/smartfm/models/notification.rb", "lib/smartfm/models/sentence.rb", "lib/smartfm/models/user.rb", "lib/smartfm/models.rb", "lib/smartfm/modules", "lib/smartfm/modules/acts_as_likable.rb", "lib/smartfm/modules/media_support.rb", "lib/smartfm/modules/private_content.rb", "lib/smartfm/modules/public_content.rb", "lib/smartfm/modules.rb", "lib/smartfm/rest_clients", "lib/smartfm/rest_clients/base.rb", "lib/smartfm/rest_clients/item.rb", "lib/smartfm/rest_clients/like.rb", "lib/smartfm/rest_clients/list.rb", "lib/smartfm/rest_clients/notification.rb", "lib/smartfm/rest_clients/sentence.rb", "lib/smartfm/rest_clients/user.rb", "lib/smartfm/rest_clients.rb", "lib/smartfm.rb", "examples/pure_ruby.rb"]
  s.has_rdoc = true
  s.homepage = %q{http://smartfm.rubyforge.org}
  s.rdoc_options = ["--title", "smartfm documentation", "--charset", "utf-8", "--opname", "index.html", "--line-numbers", "--main", "README", "--inline-source", "--exclude", "^(examples|extras)/"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{smartfm}
  s.rubygems_version = %q{1.3.2}
  s.summary = %q{A rubygem for smart.fm APIs}
  s.test_files = ["test/smartfm_test.rb"]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<json>, [">= 0"])
      s.add_runtime_dependency(%q<oauth>, [">= 0"])
    else
      s.add_dependency(%q<json>, [">= 0"])
      s.add_dependency(%q<oauth>, [">= 0"])
    end
  else
    s.add_dependency(%q<json>, [">= 0"])
    s.add_dependency(%q<oauth>, [">= 0"])
  end
end
