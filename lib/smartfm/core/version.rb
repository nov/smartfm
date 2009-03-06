module Smartfm::Version
  MAJOR = 0
  MINOR = 3
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
