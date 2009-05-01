require File.join(File.dirname(__FILE__), '..', '..', 'spec_helper')

smart = Smartfm::Item.find(33158, :include_sentences => true)

Smartfm::Item::ATTRIBUTES.each do |attr|
  describe Smartfm::Item, "##{attr}" do
    it "should be accessible" do
      smart.should respond_to(attr)
    end
  end
end

Smartfm::Item::Response::ATTRIBUTES.each do |attr|
  describe Smartfm::Item::Response, "##{attr}" do
    it "should be accessible" do
      smart.responses.first.should respond_to(attr)
    end
  end
end

Smartfm::Item::Cue::ATTRIBUTES.each do |attr|
  describe Smartfm::Item::Cue, "##{attr}" do
    it "should be accessibles" do
      smart.cue.should respond_to(attr)
    end
  end
end

describe Smartfm::Item, '#cue' do
  it "should return a instance o Smartfm::Item::Cue" do
    smart.cue.should be_a(Smartfm::Item::Cue)
  end
end

describe Smartfm::Item, '#responses' do
  it "should return a Array of Smartfm::Item::Response" do
    smart.responses.should be_a(Array)
    smart.responses.each do |response|
      response.should be_a(Smartfm::Item::Response)
    end
  end
end

describe Smartfm::Item, '#sentences' do
  it "should return a Array of Smartfm::Sentence" do
    smart.sentences.should be_a(Array)
    smart.sentences.each do |sentence|
      sentence.should be_a(Smartfm::Sentence)
    end
  end
end

describe Smartfm::Item, '#likes' do
  it "should return a Array of Smartfm::Like" do
    smart.likes.should be_a(Array)
    smart.likes.each do |like|
      like.should be_a(Smartfm::Like)
    end
  end
end