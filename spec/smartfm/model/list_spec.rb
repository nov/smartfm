require File.join(File.dirname(__FILE__), '..', '..', 'spec_helper')

core_2000 = Smartfm::List.find(705)

Smartfm::List::ATTRIBUTES.each do |attr|
  describe Smartfm::List, "##{attr}" do
    it "should be accessible" do
      core_2000.should respond_to(attr)
    end
  end
end

Smartfm::List::READONLY_ATTRIBUTES.each do |attr|
  describe Smartfm::List, "##{attr}" do
    it "should not be nil" do
      core_2000.should_not be_nil
    end
  end
end

[:iknow, :dictation, :brainspeed].each do |application|
  Smartfm::List::Application::ATTRIBUTES.each do |attr|
    describe Smartfm::List::Application, "##{attr}" do
      it "should be accessible for #{application}" do
        core_2000.send(application).should respond_to(attr)
      end
      it "should not be nil for #{application}" do
        core_2000.send(application).send(attr).should_not be_nil unless attr == :progress
      end
    end
  end
  describe Smartfm::List::Application, "#available?" do
    it "should be true for #{application}" do
      core_2000.send(application).available?.should be_true
    end
  end
end

describe Smartfm::List::Application, "#progress" do
  it "should be nil for brainspeed" do
    core_2000.brainspeed.progress.should be_nil
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
