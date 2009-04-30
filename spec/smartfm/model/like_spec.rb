require File.join(File.dirname(__FILE__), '..', '..', 'spec_helper')

matake_likes = Smartfm::User.find('matake').likes

describe Smartfm::Like do
  it "should respond to attribute methods" do
    Smartfm::Like::ATTRIBUTES.each do |attr|
      matake_likes.first.should respond_to(attr)
    end
  end
end