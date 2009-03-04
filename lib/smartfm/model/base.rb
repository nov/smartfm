class Smartfm::Base

  def self.attributes; self::ATTRIBUTES end

  def attributes; self.class.attributes  end

  def self.deserialize(hash, params = {})
    return nil if hash.nil?

    klass = params[:as] ? params[:as] : self
    if hash.is_a?(Array)
      hash.inject([]) { |results, hash|
        hash.symbolize_keys!
        results << klass.new(hash)
      }
    else
      hash.symbolize_keys!
      klass.new(hash)
    end
  end

  def deserialize(hash, params = {})
    self.class.deserialize(hash, params)
  end

end