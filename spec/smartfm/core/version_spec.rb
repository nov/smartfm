require File.join(File.dirname(__FILE__), '..', '..', 'spec_helper')

version_params = [Smartfm::Version::MAJOR, Smartfm::Version::MINOR, Smartfm::Version::REVISION]
expected = {
  :version => version_params.join('.'),
  :name    => version_params.join('_')
}

describe Smartfm::Version, ".to_version" do
  it "should return #{expected[:version]}" do
    Smartfm::Version.to_version.should eql(expected[:version])
  end
end

describe Smartfm::Version, ".to_name" do
  it "should return #{expected[:name]}" do
    Smartfm::Version.to_name.should eql(expected[:name])
  end
end