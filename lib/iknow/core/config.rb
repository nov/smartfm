class Iknow::Config
  attr_accessor :host, :port, :user_agent, :application_name, :application_version, :application_url, :source

  @@defaults = {
    :host                => 'api.iknow.co.jp',
    :port                => 80,
    :user_agent          => 'default',
    :application_name    => 'iKnow! API',
    :application_version => Iknow::Version.to_version,
    :application_url     => 'http://iknow.rubyforge.org',
    :source              => 'iknow_api'
  }
  
  def initialize(params = {})
    @host                = params[:host]                || @@defaults[:host]
    @port                = params[:port]                || @@defaults[:port]
    @user_agent          = params[:user_agent]          || @@defaults[:user_agent]
    @application_name    = params[:application_name]    || @@defaults[:application_name]
    @application_version = params[:application_version] || @@defaults[:application_version]
    @application_url     = params[:application_url]     || @@defaults[:application_url]
    @source              = params[:source]              || @@defaults[:source]
  end
end
