require File.join(File.dirname(__FILE__), '..', '..', 'spec_helper')

describe Smartfm::RestClient::User, '::ACTIONS' do
  it "should be a Hash" do
    Smartfm::RestClient::User::ACTIONS.should be_a(Hash)
  end
end