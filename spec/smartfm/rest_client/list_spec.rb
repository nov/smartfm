require File.join(File.dirname(__FILE__), '..', '..', 'spec_helper')

describe Smartfm::RestClient::List, '::ACTIONS' do
  it "should be a Hash" do
    Smartfm::RestClient::List::ACTIONS.should be_a(Hash)
  end
end