require File.join(File.dirname(__FILE__), '..', '..', 'spec_helper')

smart = Smartfm::Item.find(33158, :include_sentences => true)

describe Smartfm::Item do
  it "should respond to attribute methods" do
    Smartfm::Item::ATTRIBUTES.each do |attr|
      smart.should respond_to(attr)
    end
    Smartfm::Item::Response::ATTRIBUTES.each do |attr|
      smart.responses.first.should respond_to(attr)
    end
    Smartfm::Item::Cue::ATTRIBUTES.each do |attr|
      smart.cue.should respond_to(attr)
    end
  end
end

describe Smartfm::Item, '#recent' do
  it "should return a Array of Smartfm::Item" do
    Smartfm::Item.recent.should be_a(Array)
    Smartfm::Item.recent.each do |item|
      item.should be_a(Smartfm::Item)
    end
  end
end

describe Smartfm::Item, '#matching' do
  it "should return a Array of Smartfm::Item" do
    Smartfm::Item.matching('smart').should be_a(Array)
    Smartfm::Item.matching('smart').each do |item|
      item.should be_a(Smartfm::Item)
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
