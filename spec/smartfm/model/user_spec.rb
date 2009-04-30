require File.join(File.dirname(__FILE__), '..', '..', 'spec_helper')

matake = Smartfm::User.find('matake')

describe Smartfm::User do
  it "should respond to attribute methods" do
    Smartfm::User::ATTRIBUTES.each do |attr|
      matake.should respond_to(attr)
    end
    Smartfm::User::Profile::ATTRIBUTES.each do |attr|
      matake.profile.should respond_to(attr)
    end
    Smartfm::User::Study::ATTRIBUTES.each do |attr|
      matake.study.should respond_to(attr)
    end
    Smartfm::User::Study::Result::ATTRIBUTES.each do |attr|
      matake.study.results.each do |result|
        result.should respond_to(attr)
      end
    end
    Smartfm::User::Study::TotalSummary::ATTRIBUTES.each do |attr|
      matake.study.total_summary.should respond_to(attr)
    end
  end
end

describe Smartfm::User, '#items' do
  it "should return a Array of Smartfm::Item or []" do
    matake.items.should be_a(Array)
    matake.items.each do |item|
      item.should be_a(Smartfm::Item)
    end
    matake.items(:page => 10000000000).should be_empty
    matake.items(:page => 10000000000).should_not be_nil
  end
end

describe Smartfm::User, '#lists' do
  it "should return a Array of Smartfm::List or []" do
    matake.lists.should be_a(Array)
    matake.lists.each do |list|
      list.should be_a(Smartfm::List)
    end
    matake.lists(:page => 10000000000).should be_empty
    matake.lists(:page => 10000000000).should_not be_nil
  end
end

describe Smartfm::User, '#friends' do
  it "should return a Array of Smartfm::User" do
    matake.friends.should be_a(Array)
    matake.friends.each do |friend|
      friend.should be_a(Smartfm::User)
    end
  end
end

describe Smartfm::User, '#followers' do
  it "should return a Array of Smartfm::User" do
    matake.followers.should be_a(Array)
    matake.followers.each do |follower|
      follower.should be_a(Smartfm::User)
    end
  end
end

describe Smartfm::User, '#likes' do
  it "should return a Array of Smartfm::Like" do
    matake.likes.should be_a(Array)
    matake.likes.each do |like|
      like.should be_a(Smartfm::Like)
    end
  end
end

describe Smartfm::User, '#notifications' do
  it "should return a Array of Smartfm::Notification" do
    matake.notifications.should be_a(Array)
    matake.notifications.each do |notification|
      notification.should be_a(Smartfm::Notification)
    end
  end
end

describe Smartfm::User, '#study' do
  it "should return a instance of Smartfm::User::Study" do
    matake.study.should be_a(Smartfm::User::Study)
    matake.study(:application => 'iknow').should be_a(Smartfm::User::Study)
    matake.study(:application => 'dictation').should be_a(Smartfm::User::Study)
    matake.study(:application => 'brainspeed').should be_a(Smartfm::User::Study)
    matake.study(:application => 'fuckin_windows').should be_nil
  end
end

describe Smartfm::User::Study, '#results' do
  it "should return a Array of Smartfm::User::Study::Result" do
    matake.study.results.should be_a(Array)
    matake.study.results.each do |result|
      result.should be_a(Smartfm::User::Study::Result)
    end
  end
end

describe Smartfm::User::Study, '#total_summary' do
  it "should return a Array of Smartfm::User::Study::TotalSummary" do
    matake.study.total_summary.should be_a(Smartfm::User::Study::TotalSummary)
  end
end