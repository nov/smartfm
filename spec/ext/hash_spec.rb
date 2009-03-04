require File.join(File.dirname(__FILE__), '..', 'spec_helper')

describe Hash, "#to_http_str" do
  before do
    @params = {:page => 3, :per_page => 100}
  end
  it "should return http_parameter as String" do
    @params.to_http_str.should be_a(String)
    @params.to_http_str.should match(/^(page=3&per_page=100|per_page=100&page=3)$/)
  end
end
