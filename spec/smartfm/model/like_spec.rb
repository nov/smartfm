require File.join(File.dirname(__FILE__), '..', '..', 'spec_helper')

matake_likes = Smartfm::User.find('matake').likes

Smartfm::Like::ATTRIBUTES.each do |attr|
  describe Smartfm::Like, "##{attr}" do
    it "should be accessible" do
      matake_likes.first.should respond_to(attr)
    end
  end
end

Smartfm::Like::ATTRIBUTES.each do |attr|
  describe Smartfm::Like, "##{attr}" do
    it "should not be nil" do
      matake_likes.first.should_not be_nil
    end
  end
end