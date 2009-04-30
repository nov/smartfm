require File.join(File.dirname(__FILE__), '..', '..', 'spec_helper')

describe String do
  it "should respond to length" do
    "hoge".should respond_to(:length)
  end
end