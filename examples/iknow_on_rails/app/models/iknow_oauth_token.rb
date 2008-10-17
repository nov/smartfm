require 'oauth/consumer'

class IknowOauthToken < ActiveRecord::Base

  def self.consumer
    @@consumer ||= OAuth::Consumer.new(
      Iknow::Config.oauth_consumer_key,
      Iknow::Config.oauth_consumer_secret,
      :site          => Iknow::Config.iknow_api_base_url,
      :authorize_url => "#{Iknow::Config.iknow_base_url}/oauth/authorize"
    )
  end

  def self.new_request_token
    begin
      self.consumer.get_request_token
    rescue Exception => e
      nil
    end
  end

  def self.establish_auth_token(iknow_username, request_token)
    access_token = request_token.get_access_token

    auth_token          = IknowAuthToken.new
    auth_token.username = iknow_username
    auth_token.token    = access_token.token
    auth_token.secret   = access_token.secret
    auth_token.save!
  end

  def to_access_token
    OAuth::AccessToken.new(self.class.consumer, self.token, self.secret)
  end

end

