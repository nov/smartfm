class Hash
  def to_http_str
    result = ''
    return result if self.empty?
    self.each do |key, val|
      result << "#{key}=#{URI.encode(val.to_s)}&"
    end
    result.chop
  end
end