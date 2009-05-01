module Smartfm::Version
  MAJOR = 1
  MINOR = 0
  REVISION = 1
  class << self
    def to_version
      "#{MAJOR}.#{MINOR}.#{REVISION}"
    end
    
    def to_name
      "#{MAJOR}_#{MINOR}_#{REVISION}"
    end
  end
end
