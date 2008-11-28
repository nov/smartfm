class Hash
  def to_http_str
    result = ''
    return result if self.empty?
    self.each do |key, val|
      result << "#{key}=#{URI.encode(val.to_s)}&"
    end
    result.chop
  end
  def symbolize_keys!
    self.each do |key, value|
      unless self.delete(key.to_s).nil?
        if value.is_a?(Hash)
          value.symbolize_keys!
        elsif value.is_a?(Array)
          value.map!{ |v| v.symbolize_keys! if v.is_a?(Hash) }
        end
        self[key.to_sym] = value
      end
    end  
    self
  end
end