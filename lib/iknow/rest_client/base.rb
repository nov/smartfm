class Iknow::RestClient::Base

  class RESTError < Exception
    attr_accessor :code, :message, :uri
    
    def initialize(params = {})
      self.code    = params[:code]
      self.message = params[:message]
      self.uri     = params[:uri]
    end
    
    def to_s
      "HTTP #{@code}: #{@message} at #{@uri}"
    end
  end
  class ResourceError < RESTError            ; end
  class ResourceNotFound < ResourceError     ; end
  class ResourceAccessDenied < ResourceError ; end

  def self.valid_action?(action) ; self::ACTIONS.keys.include? action.to_sym          end
  def self.path(action)          ; self::ACTIONS[action.to_sym][:path]                end
  def self.http_method(action)   ; self::ACTIONS[action.to_sym][:http_method] || :get end

  def self.post_with_auth_token(auth_token, uri, data)
    response = auth_token.to_access_token.post(uri, data)
    response
  end

  def self.method_missing(action, *args)
    # GET methods are handled here
    # POST and DELETE methods should be implemented in each class
    super unless self.valid_action?(action) and self.http_method(action) == :get
    http_connect do |conn|
      http_get_request( replace_uri_params(self.path(action), args[0]) )
    end
  end

  private

  def self.config; Iknow::Config.instance end
  
  def self.http_connect
    connection = Net::HTTP.new(self.config.host, self.config.port)
    connection.start do |conn|
      request  = yield connection
      response = conn.request(request)
      handle_rest_response(response)
      json_response = JSON.parse(response.body)
      handle_json_response(json_response)
      json_response
    end
  end

  def self.raise_json_error(code, message, uri = nil)
    case code
    when 403
      raise ResourceAccessDenied.new(:code => code, :message => message, :uri => uri)
    when 404
      raise ResourceNotFound.new(:code => code, :message => message, :uri => uri)
    else
      raise ResourceError.new(:code => code, :message => message, :uri => uri)
    end
  end

  def self.raise_rest_error(response, uri = nil)
    raise RESTError.new(:code => response.code, :message => response.message, :uri => uri)        
  end
  
  def self.handle_json_response(json_response, uri = nil)
    jsoon_error = json_response.is_a?(Hash) ? json_response['error'] : nil
    raise_json_error(jsoon_error['code'], jsoon_error['message'], uri) unless jsoon_error.nil?
  end

  def self.handle_rest_response(response, uri = nil)
    raise_rest_error(response, uri) unless response.is_a?(Net::HTTPSuccess)
  end

  def self.http_header
    @@http_header ||= { 
      'User-Agent'             => "iKnow! API v#{Iknow::Version.to_version} [#{self.config.user_agent}]",
      'Accept'                 => 'text/x-json',
      'X-iKnow-Client'         => self.config.application_name,
      'X-iKnow-Client-Version' => self.config.application_version,
      'X-iKnow-Client-URL'     => self.config.application_url,
    }
    @@http_header
  end

  def self.replace_uri_params(uri, params = {})
    unless params.empty?
      params.each do |key, value|
        if uri=~/__#{key}__/
          uri.sub!(/__#{key}__/, value.to_s)
          params.delete(key)
        end
      end
    end
    return uri, params
  end

  def self.http_get_request(uri, params = {})
    path = (params.size > 0) ? "#{uri}?#{params.to_http_str}" : uri
    Net::HTTP::Get.new(path, http_header)
  end

  def self.http_post_request(uri, params = {})
    Net::HTTP::Post.new(uri, http_header)
  end

  def self.http_delete_request(uri, params = {})
    path = (params.size > 0) ? "#{uri}?#{params.to_http_str}" : uri
    Net::HTTP::Delete.new(path, http_header)
  end

  private_class_method :http_connect, :raise_rest_error, :handle_rest_response, :http_header, :replace_uri_params,
                       :http_get_request, :http_post_request, :http_delete_request

end