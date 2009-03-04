require 'oauth/consumer'

class Smartfm::Auth
  attr_accessor :mode, :auth_token

  class Basic
    attr_reader :username, :password

    def initialize(username, password)
      @username = username
      @password = password
    end
  end

  def initialize(options = {})
    if options[:username] && options[:password]
      @mode = :basic_auth
      @auth_token = Basic.new(options[:username], options[:password])
    elsif options[:token] && options[:secret]
      @mode = :oauth
      @auth_token = OAuth::AccessToken.new(Smartfm::Auth.consumer, options[:token], options[:secret])
    else
      raise ArgumentError.new('{:auth => "oauth_access_token", :secret => "oauth_access_token_secret"} or {:username "smartfm_username", :password => "smartfm_password"} is needed')
    end
  end

  def self.consumer
    @@consumer ||= OAuth::Consumer.new(
      Smartfm::Config.oauth_consumer_key,
      Smartfm::Config.oauth_consumer_secret,
      :http_method   => Smartfm::Config.oauth_http_method,
      :scheme        => Smartfm::Config.oauth_scheme,
      :site          => Smartfm::Config.api_base_url,
      :authorize_url => "#{Smartfm::Config.base_url}/oauth/authorize"
    )
  end

  alias_method :account, :auth_token
end
