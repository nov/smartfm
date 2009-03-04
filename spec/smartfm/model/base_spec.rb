require File.join(File.dirname(__FILE__), '..', '..', 'spec_helper')

subclasses = [ Smartfm::Item, Smartfm::List, Smartfm::Sentence, Smartfm::User ]

subclasses.each do |klass|

  describe klass, '.attributes' do
    it "should return Array of attributes" do
      klass.attributes.should be_a(Array)
    end
  end

  describe klass, '.find' do
    it "should return nil if NOT FOUND" do
      klass.find(-1).should be_nil
    end
  end

  if klass.respond_to?(:recent)
    describe klass, '.recent' do
      it "should return Array" do
        klass.recent.should be_a(Array)
        # blank response should be []
        klass.recent(:per_page => 20, :page => 100000000000000).should be_empty
        klass.recent(:per_page => 20, :page => 100000000000000).should_not be_nil
      end
    end
  end
  
  if klass.respond_to?(:matching)
    describe klass, '.recent' do
      it "should return Array" do
        klass.matching("hello").should be_a(Array)
        klass.matching(rand_string).should be_empty
        klass.matching(rand_string).should_not be_nil
      end
    end
  end

end