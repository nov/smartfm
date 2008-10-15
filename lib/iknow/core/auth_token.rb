require 'oauth/consumer'

class Iknow::AuthToken
  attr_reader :auth_user, :auth_token, :auth_secret

  def self.consumer
    conf = Iknow::Config.instance
    @@consumer ||= OAuth::Consumer.new(
      conf.iknow_oauth_key,
      conf.iknow_oauth_secret,
      :site          => conf.iknow_base_url,
      :authorize_url => "#{conf.iknow_base_url}/oauth/authorize"
    )
    @@consumer
  end

  def initialize(params = {})
    @auth_user   = params[:auth_user]
    @auth_token  = params[:auth_token]
    @auth_secret = params[:auth_secret]
  end

  def to_access_token
    OAuth::AccessToken.new(Iknow::AuthToken.consumer, self.auth_token, self.auth_secret)
  end

end