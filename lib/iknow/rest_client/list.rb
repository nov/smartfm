class Iknow::RestClient::List < Iknow::RestClient::Base
  
  ACTIONS = {
    :recent    => { :path => '/lists'                                 },
    :items     => { :path => '/lists/__id__/items'                    },
    :sentences => { :path => '/lists/__id__/sentences'                },
    :matching  => { :path => '/lists/matching/__keyword__'            },
    :create    => { :path => '/lists',        :http_method => :post   },
    :delete    => { :path => '/lists/__id__', :http_method => :delete }
  }

  def self.create(auth_token, list)
    raise ArgumentError.new("auth_token is needed.") unless auth_token.is_a?(Iknow::AuthToken)
    
    list_params = setup_list_params(list)
    self.post_with_auth_token(auth_token, "#{self.config.iknow_base_url}#{ACTIONS[:create][:path]}", list_params)
  end

  private

  def self.setup_list_params(list)
    raise ArgumentError.new("List title is needed.") if list.title.nil? or list.title.empty?
    
    list_params = {
      'list[name]'                 => list.title,
      'list[description]'          => list.description,
      'list[language]'             => list.language             || 'en',
      'list[translation_language]' => list.translation_language || 'ja'
    }
    # Object#type should not be used
    if list_type = list.list_type
      list_params['list[type]'] = list_type
    end
    # Optional attributes
    [ :transcript, :embed, :tags, :media_entry,
      :author, :author_url, :attribution_license_id ].each do |key|
      if value = list.send("#{key}")
        list_params["list[#{key}]"] = value
      end
    end
    list_params
  end

  private_class_method :setup_list_params

end