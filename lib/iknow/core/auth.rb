require 'oauth/consumer'

class Iknow::Auth
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
      @auth_token = OAuth::AccessToken.new(Iknow::Auth.consumer, options[:token], options[:secret])
    else
      raise ArgumentError.new('{:auth => "oauth_access_token", :secret => "oauth_access_token_secret"} or {:username "iknow_username", :password => "iknow_password"} is needed')
    end
  end

  def self.consumer
    @@consumer ||= OAuth::Consumer.new(
      Iknow::Config.oauth_consumer_key,
      Iknow::Config.oauth_consumer_secret,
      :http_method   => Iknow::Config.oauth_http_method,
      :scheme        => Iknow::Config.oauth_scheme,
      :site          => Iknow::Config.api_base_url,
      :authorize_url => "#{Iknow::Config.base_url}/oauth/authorize"
    )
  end

  alias_method :account, :auth_token
end
