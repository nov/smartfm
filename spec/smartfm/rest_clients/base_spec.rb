require File.join(File.dirname(__FILE__), '..', '..', 'spec_helper')

subclasses = [ Smartfm::RestClient::Item, Smartfm::RestClient::List, Smartfm::RestClient::Sentence, Smartfm::RestClient::User ]

describe Smartfm::RestClient::Base do
  it "should be a Class" do
    true
  end
end