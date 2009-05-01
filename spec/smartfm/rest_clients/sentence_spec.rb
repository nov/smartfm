require File.join(File.dirname(__FILE__), '..', '..', 'spec_helper')

describe Smartfm::RestClient::Sentence, '::ACTIONS' do
  it "should be a Hash" do
    Smartfm::RestClient::Sentence::ACTIONS.should be_a(Hash)
  end
end