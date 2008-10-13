class Iknow::RestClient::Base

  @@config = Iknow::Config.new

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

  def self.valid_action?(action) ; self::ACTIONS.keys.include? action.to_sym          end
  def self.path(action)          ; self::ACTIONS[action.to_sym][:path]                end
  def self.http_method(action)   ; self::ACTIONS[action.to_sym][:http_method] || :get end

  def self.method_missing(action, *args)
    super unless self.valid_action? action
    path, params = replace_uri_params(self.path(action), args[0])
    http_connect do |conn|
      case self.http_method(action).to_sym
      when :delete
        http_delete_request path, params
      when :post
        http_post_request   path, params
      else
        http_get_request    path, params
      end
    end
  end

  private

  def self.http_connect(&block)
    connection = Net::HTTP.new(@@config.host, @@config.port)
    request    = yield connection
    connection.start do |conn|
      response = conn.request(request)
      handle_rest_response(response)
      JSON.parse(response.body)
    end
  end

  def self.raise_rest_error(response, uri = nil)
    raise RESTError.new(:code => response.code, :message => response.message, :uri => uri)        
  end

  def self.handle_rest_response(response, uri = nil)
    unless response.is_a?(Net::HTTPSuccess)
      raise_rest_error(response, uri)
    end
  end

  def self.http_header
    # can cache this in class variable since all "variables" used to 
    # create the contents of the HTTP header are determined by other 
    # class variables that are not designed to change after instantiation.
    @@http_header ||= { 
      'User-Agent'             => "iKnow! API v#{Iknow::Version.to_version} [#{@@config.user_agent}]",
      'Accept'                 => 'text/x-json',
      'X-iKnow-Client'         => @@config.application_name,
      'X-iKnow-Client-Version' => @@config.application_version,
      'X-iKnow-Client-URL'     => @@config.application_url,
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