require 'rails_generator/base'

class IknowOauthGenerator < Rails::Generator::Base
	def manifest
		record do |m|
		  m.class_collisions 'IknowOauthController', 'IknowOauthControllerTest', 'IknowOauthHelper',
		                     'IknowOauthSystem', 'IknowOauthToken', 'IknowOauthTokenTest'

		  m.migration_template 'iknow_oauth_tokens_migration.rb', 'db/migrate', :migration_file_name => 'create_iknow_oauth_tokens'

			m.template 'iknow_oauth_controller.rb',      File.join('app/controllers', 'iknow_oauth_controller.rb'     )
      m.template 'iknow_oauth_controller_test.rb', File.join('test/functional', 'iknow_oauth_controller_test.rb')
			m.template 'iknow_oauth_helper.rb',          File.join('app/helpers',     'iknow_oauth_helper.rb'         )
		  m.template 'iknow_oauth_system.rb',          File.join('lib',             'iknow_oauth_system.rb'         )
			m.template 'iknow_oauth_token.rb',           File.join('app/models',      'iknow_oauth_token.rb'          )
			m.template 'iknow_oauth_token_test.rb',      File.join('test/unit',       'iknow_oauth_token_test.rb'     )

      m.directory File.join('app/views', 'iknow_oauth')
      m.template 'index.rhtml', File.join('app/views', 'iknow_oauth', 'index.rhtml')
		end
	end
end
