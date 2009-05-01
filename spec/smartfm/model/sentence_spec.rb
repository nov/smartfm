require File.join(File.dirname(__FILE__), '..', '..', 'spec_helper')

smartest = Smartfm::Sentence.find(10828)

Smartfm::Sentence::ATTRIBUTES.each do |attr|
  describe Smartfm::Sentence, "##{attr}" do
    it "should be accessible" do
      smartest.should respond_to(attr)
    end
  end
end