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

  def self.valid_action?(action) ; self::ACTIONS.keys.include? action.to_sym          end
  def self.path(action)          ; self::ACTIONS[action.to_sym][:path]                end
  def self.http_method(action)   ; self::ACTIONS[action.to_sym][:http_method] || :get end

  def self.method_missing(action, *args)
    # GET methods are handled here
    # POST and DELETE methods should be implemented in each class
    super unless self.valid_action?(action)
    uri, params = replace_uri_params(self.path(action), args[0])
    http_connect do |conn|
      case self.http_method(action)
      when :get
        http_get_request(uri, params)
      when :post
        http_post_request(uri, params)
      when :delete
        http_delete_request(uri, params)
      end
    end
  end

  private

  def self.config; Iknow::Config end
  
  def self.api_key_required
    raise ArgumentError.new("iKnow! API key is required") if self.config.api_key == ''
  end

  def self.http_connect
    connection = Net::HTTP.new(self.config.api_host, self.config.api_port)
    connection.start do |conn|
      request  = yield connection
      response = conn.request(request)
      handle_rest_response(response)
      JSON.parse(response.body)
    end
  end

  def self.raise_rest_error(response, uri = nil)
    raise RESTError.new(:code => response.code, :message => response.message, :uri => uri)
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
    replaced_uri = uri.clone
    unless params.empty?
      params.each do |key, value|
        if replaced_uri=~/__#{key}__/
          replaced_uri.sub!(/__#{key}__/, value.to_s)
          params.delete(key)
        end
      end
    end
    return replaced_uri, params
  end

  def self.http_get_request(uri, params = {})
    unless self.config.api_key == ''
      params.merge!(:api_key => self.config.api_key)
    end
    path = (params.size > 0) ? "#{uri}?#{params.to_http_str}" : uri
    Net::HTTP::Get.new(path, http_header)
  end

  def self.http_post_request(uri, params = {})
    self.api_key_required
    request = Net::HTTP::Post.new(uri, http_header)
    request.body = params.merge(:api_key => self.config.api_key).to_http_str
    request
  end

  def self.http_delete_request(uri, params = {})
    unless self.config.api_key == ''
      params.merge!(:api_key => self.config.api_key)
    end
    path = (params.size > 0) ? "#{uri}?#{params.to_http_str}" : uri
    Net::HTTP::Delete.new(path, http_header)
  end

  private_class_method :http_connect, :raise_rest_error, :handle_rest_response, :http_header,
                       :replace_uri_params, :http_get_request, :http_post_request, :http_delete_request

end