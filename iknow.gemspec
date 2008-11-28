Gem::Specification.new do |s|
  s.name = %q{iknow}
  s.version = "0.0.4"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["nov"]
  s.date = %q{2008-11-29}
  s.description = %q{A rubygem for iKnow! APIs}
  s.email = %q{developer@iknow.co.jp}
  s.extra_rdoc_files = ["README", "ChangeLog"]
  s.files = ["README", "ChangeLog", "Rakefile", "test/iknow_test.rb", "test/test_helper.rb", "lib/ext", "lib/ext/hash.rb", "lib/iknow", "lib/iknow/core", "lib/iknow/core/config.rb", "lib/iknow/core/version.rb", "lib/iknow/core.rb", "lib/iknow/model", "lib/iknow/model/base.rb", "lib/iknow/model/item.rb", "lib/iknow/model/list.rb", "lib/iknow/model/sentence.rb", "lib/iknow/model/user.rb", "lib/iknow/model.rb", "lib/iknow/rest_client", "lib/iknow/rest_client/base.rb", "lib/iknow/rest_client/item.rb", "lib/iknow/rest_client/list.rb", "lib/iknow/rest_client/sentence.rb", "lib/iknow/rest_client/user.rb", "lib/iknow/rest_client.rb", "lib/iknow.rb", "generators/iknow_oauth", "generators/iknow_oauth/iknow_oauth_generator.rb", "generators/iknow_oauth/templates", "generators/iknow_oauth/templates/iknow_oauth_controller.rb", "generators/iknow_oauth/templates/iknow_oauth_controller_test.rb", "generators/iknow_oauth/templates/iknow_oauth_helper.rb", "generators/iknow_oauth/templates/iknow_oauth_system.rb", "generators/iknow_oauth/templates/iknow_oauth_token.rb", "generators/iknow_oauth/templates/iknow_oauth_token_test.rb", "generators/iknow_oauth/templates/iknow_oauth_tokens_migration.rb", "generators/iknow_oauth/templates/index.rhtml", "generators/iknow_oauth/USAGE", "examples/iknow_on_rails/app/controllers/application.rb", "examples/iknow_on_rails/app/controllers/iknow_oauth_controller.rb", "examples/iknow_on_rails/app/controllers/users_controller.rb", "examples/iknow_on_rails/app/helpers/application_helper.rb", "examples/iknow_on_rails/app/helpers/iknow_oauth_helper.rb", "examples/iknow_on_rails/app/helpers/users_helper.rb", "examples/iknow_on_rails/app/models/iknow_oauth_token.rb", "examples/iknow_on_rails/config/boot.rb", "examples/iknow_on_rails/config/environment.rb", "examples/iknow_on_rails/config/environments/development.rb", "examples/iknow_on_rails/config/environments/production.rb", "examples/iknow_on_rails/config/environments/test.rb", "examples/iknow_on_rails/config/initializers/inflections.rb", "examples/iknow_on_rails/config/initializers/mime_types.rb", "examples/iknow_on_rails/config/initializers/new_rails_defaults.rb", "examples/iknow_on_rails/config/routes.rb", "examples/iknow_on_rails/db/migrate/20081017012212_create_iknow_oauth_tokens.rb", "examples/iknow_on_rails/db/schema.rb", "examples/iknow_on_rails/lib/iknow_oauth_system.rb", "examples/iknow_on_rails/public/dispatch.rb", "examples/iknow_on_rails/test/functional/iknow_oauth_controller_test.rb", "examples/iknow_on_rails/test/functional/users_controller_test.rb", "examples/iknow_on_rails/test/test_helper.rb", "examples/iknow_on_rails/test/unit/iknow_oauth_token_test.rb", "examples/pure_ruby.rb"]
  s.has_rdoc = true
  s.homepage = %q{http://iknow.rubyforge.org}
  s.rdoc_options = ["--title", "iknow documentation", "--charset", "utf-8", "--opname", "index.html", "--line-numbers", "--main", "README", "--inline-source", "--exclude", "^(examples|extras)/"]
  s.require_paths = ["lib"]
  s.required_ruby_version = Gem::Requirement.new(">= 1.8.6")
  s.rubyforge_project = %q{iknow}
  s.rubygems_version = %q{1.2.0}
  s.summary = %q{A rubygem for iKnow! APIs}
  s.test_files = ["test/iknow_test.rb"]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if current_version >= 3 then
      s.add_runtime_dependency(%q<rails>, [">= 2.1.0"])
      s.add_runtime_dependency(%q<json>, [">= 0"])
      s.add_runtime_dependency(%q<oauth>, ["= 0.2.4"])
    else
      s.add_dependency(%q<rails>, [">= 2.1.0"])
      s.add_dependency(%q<json>, [">= 0"])
      s.add_dependency(%q<oauth>, ["= 0.2.4"])
    end
  else
    s.add_dependency(%q<rails>, [">= 2.1.0"])
    s.add_dependency(%q<json>, [">= 0"])
    s.add_dependency(%q<oauth>, ["= 0.2.4"])
  end
end
