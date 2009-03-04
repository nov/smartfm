require File.join(File.dirname(__FILE__), '..', '..', 'spec_helper')

describe Smartfm::Config, ".init" do
  before do
    Smartfm::Config.init
  end

  it "should return init config" do
    Smartfm::Config.init.should equal(Smartfm::Config.instance)
  end

  it "should change config with block" do
    Smartfm::Config.init do |conf|
      Smartfm::Config::ATTRIBUTES.each do |method|
        conf.send("#{method}=", "fuckin_windows!")
      end
    end
    Smartfm::Config::ATTRIBUTES.each do |method|
      Smartfm::Config.send("#{method}").should eql("fuckin_windows!")
    end
  end

  after do
    Smartfm::Config.init
  end
end

(Smartfm::Config::ATTRIBUTES + [:base_url, :api_base_url]).each do |method|
  describe Smartfm::Config, ".#{method}" do
    it "should be same with Smartfm::Config.instance.#{method}" do
      Smartfm::Config.send(method).should eql(Smartfm::Config.instance.send(method))
    end
  end
end