module Iknow::Version
  MAJOR = 0
  MINOR = 2
  REVISION = 3
  class << self
    def to_version
      "#{MAJOR}.#{MINOR}.#{REVISION}"
    end
    
    def to_name
      "#{MAJOR}_#{MINOR}_#{REVISION}"
    end
  end
end
