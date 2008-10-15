require 'singleton'

class Iknow::Config
  include Singleton
  attr_accessor :protocol, :host, :port, :user_agent, :iknow_oauth_key, :iknow_oauth_secret, :application_name, :application_version, :application_url, :source

  def self.init(&block)
    conf = Iknow::Config.instance
    { :protocol            => 'http',
      :host                => 'api.iknow.co.jp',
      :port                => 80,
      :user_agent          => 'default',
      :iknow_oauth_key     => '',
      :iknow_oauth_secret  => '',
      :application_name    => 'iKnow! API',
      :application_version => Iknow::Version.to_version,
      :application_url     => 'http://github.com/nov/iknow',
      :source              => 'iknow'
    }.each do |key, value| conf.send("#{key}=", value) end
    yield conf if block_given?
  end
  
  def iknow_base_url
    port = self.port==80 ? nil : ":#{self.port}"
    "#{self.protocol}://#{self.host}#{port}"
  end

end
