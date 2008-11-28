class Iknow::Base

  def self.attributes; self::ATTRIBUTES end

  def attributes; self.class.attributes  end

  def self.deserialize(response, params = {})
    return nil if response.nil? or
                 (response.is_a?(Hash) and
                 !response['error'].nil? and
                  response['error']['code'].to_i == 404)

    klass = params[:as] ? params[:as] : self
    if response.is_a?(Array)
      response.inject([]) { |results, hash|
        hash.symbolize_keys!
        results << klass.new(hash)
      }
    else
      response.symbolize_keys!
      klass.new(response)
    end
  end

  def deserialize(response, params = {})
    self.class.deserialize(response, params)
  end

end