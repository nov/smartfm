require File.join(File.dirname(__FILE__), '..', '..', 'spec_helper')

basic_auth_params = { :username => 'matake', :password => 'password' }
oauth_params      = { :token => '1a2b3c4d5', :secret => 'z0y9x8w7v6' }

describe Smartfm::Auth, '.new' do
  before do
    @basic_auth = Smartfm::Auth.new(basic_auth_params)
    @oauth      = Smartfm::Auth.new(oauth_params)
  end

  it "should choose #{:basic_auth} mode" do
    @basic_auth.mode.should equal(:basic_auth)
    @basic_auth.should respond_to(:account)
    @basic_auth.account.should respond_to(:username)
    @basic_auth.account.should respond_to(:password)
    @basic_auth.account.should_not respond_to(:token)
    @basic_auth.account.should_not respond_to(:secret)
  end

  it "should choose #{:oauth} mode" do
    @oauth.mode.should equal(:oauth)
    @oauth.should respond_to(:auth_token)
    @oauth.auth_token.should respond_to(:token)
    @oauth.auth_token.should respond_to(:secret)
    @oauth.auth_token.should_not respond_to(:username)
    @oauth.auth_token.should_not respond_to(:password)
  end
end

describe Smartfm::Auth, '.consumer' do
  it "should be an instance of OAuth::Consumer" do
    Smartfm::Auth.consumer.should be_a(OAuth::Consumer)
  end

  it "should be for http://api.smart.fm" do
    Smartfm::Auth.consumer.site.should eql("http://api.smart.fm")
  end
end