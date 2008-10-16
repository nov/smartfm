class Iknow::Base
  # TODO: define self.attributes
  def self.attributes; self::ATTRIBUTES end
  def attributes; self.class.attributes  end

  def self.deserialize(response, params = {})
    klass = params[:as]   ? params[:as] : self
    response.is_a?(Array) ? response.inject([]) { |results, params| results << klass.new(params) } : klass.new(response)
  end
  def deserialize(response, params = {})
    self.class.deserialize(response, params)
  end

end