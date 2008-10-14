require 'singleton'

class Iknow::Config
  include Singleton
  attr_accessor :host, :port, :user_agent, :application_key, :application_name, :application_version, :application_url, :source

  API_KEY = ''

  def self.init(&block)
    conf = Iknow::Config.instance
    { :host                => 'api.iknow.co.jp',
      :port                => 80,
      :user_agent          => 'default',
      :application_key     => '',
      :application_name    => 'iKnow! API',
      :application_version => Iknow::Version.to_version,
      :application_url     => 'http://github.com/nov/iknow',
      :source              => 'iknow'
    }.each do |key, value| conf.send("#{key}=", value) end
    yield conf if block_given?
  end
  
end
