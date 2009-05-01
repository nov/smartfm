require File.join(File.dirname(__FILE__), '..', '..', 'spec_helper')

describe Smartfm::RestClient::Item, '::ACTIONS' do
  it "should be a Hash" do
    Smartfm::RestClient::Item::ACTIONS.should be_a(Hash)
  end
end