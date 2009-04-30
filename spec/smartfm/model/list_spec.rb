require File.join(File.dirname(__FILE__), '..', '..', 'spec_helper')

core_2000 = Smartfm::List.find(705)

describe Smartfm::List do
  it "should respond to attribute methods" do
    Smartfm::List::ATTRIBUTES.each do |attr|
      core_2000.should respond_to(attr)
    end
    Smartfm::List::Application::ATTRIBUTES.each do |attr|
      core_2000.iknow.should respond_to(attr)
      core_2000.dictation.should respond_to(attr)
      core_2000.brainspeed.should respond_to(attr)
    end
  end
end

describe Smartfm::List, '#items' do
  it "should return a Array of Smartfm::Item" do
    core_2000.items.should be_a(Array)
    core_2000.items.each do |item|
      item.should be_a(Smartfm::Item)
    end
  end
end

describe Smartfm::List, '#sentences' do
  it "should return a Array of Smartfm::Sentence" do
    core_2000.sentences.should be_a(Array)
    core_2000.sentences.each do |sentence|
      sentence.should be_a(Smartfm::Sentence)
    end
  end
end

describe Smartfm::List, '#likes' do
  it "should return a Array of Smartfm::Like" do
    core_2000.likes.should be_a(Array)
    core_2000.likes.each do |like|
      like.should be_a(Smartfm::Like)
    end
  end
end