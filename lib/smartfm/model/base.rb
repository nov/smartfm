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

  def attribution_params(attr_params)
    return {} unless attr_params
    {
      'attribution[medias_entity]'           => attr_params[:media_entity],
      'attribution[author]'                  => attr_params[:author],
      'attribution[author_url]'              => attr_params[:author_url],
      'attributions[attribution_license_id]' => attr_params[:attribution_license_id]
    }
  end

end