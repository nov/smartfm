require 'singleton'

class Smartfm::Config
  include Singleton
  ATTRIBUTES = [ :protocol, :host, :port, :api_protocol, :api_host, :api_port, :api_key, :timeout,
                 :oauth_consumer_key, :oauth_consumer_secret, :oauth_http_method, :oauth_scheme,
                 :user_agent, :application_name, :application_version, :application_url ]
  attr_accessor *ATTRIBUTES

  def self.init(&block)
    conf = Smartfm::Config.instance
    { :protocol              => 'http',
      :host                  => 'smart.fm',
      :port                  => 80,
      :api_protocol          => 'http',
      :api_host              => 'api.smart.fm',
      :api_port              => 80,
      :api_key               => '',
      :timeout               => 30,
      :oauth_consumer_key    => '',
      :oauth_consumer_secret => '',
      :oauth_http_method     => :post,
      :oauth_scheme          => :header,
      :user_agent            => 'default',
      :application_name      => 'smart.fm gem',
      :application_version   => Smartfm::Version.to_version,
      :application_url       => 'http://github.com/nov/smartfm'
    }.each do |key, value| conf.send("#{key}=", value) end
    yield conf if block_given?
    conf
  end

  def base_url
    port = self.port==80 ? nil : ":#{self.port}"
    "#{self.protocol}://#{self.host}#{port}"
  end

  def api_base_url
    port = self.api_port==80 ? nil : ":#{self.api_port}"
    "#{self.api_protocol}://#{self.api_host}#{port}"
  end

  # hack: Object.timeout is already defined..
  def self.timeout
    instance.timeout
  end

  def self.method_missing(method, *args)
    Smartfm::Config.instance.send(method, *args)
  end
end