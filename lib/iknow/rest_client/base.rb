class Iknow::RestClient::Base

  class RESTError < Exception
    attr_accessor :code, :message

    def initialize(params = {})
      self.code    = params[:code]
      self.message = params[:message]
    end

    def to_s
      "HTTP #{@code}: #{@message}"
    end
  end

  def self.valid_action?(action) ; self::ACTIONS.keys.include? action.to_sym          end
  def self.path(action)          ; self::ACTIONS[action.to_sym][:path]                end
  def self.http_method(action)   ; self::ACTIONS[action.to_sym][:http_method] || :get end

  def self.method_missing(action, *args)
    # GET methods are handled here
    # POST and DELETE methods should be implemented in each class
    super unless self.valid_action?(action)
    case self.http_method(action)
    when :get
      path, params = path_with_params(self.path(action), args[0])
      http_get_request(path, params)
    when :post
      path, params = path_with_params(self.path(action), args[1])
      http_post_request(iknow_auth(args[0]), path, params)
    when :delete
      path, params = path_with_params(self.path(action), args[1])
      http_delete_request(iknow_auth(args[0]), path, params)
    end
  end

  private

  def self.config; Iknow::Config end

  def self.iknow_auth(iknow_auth)
    if iknow_auth.is_a?(Iknow::Auth)
      iknow_auth
    else
      raise ArgumentError.new("Authorized Iknow::Auth instance is required")
    end
  end
  
  def self.api_key_required
    raise ArgumentError.new("iKnow! API key is required") if self.config.api_key == ''
  end

  def self.raise_rest_error(response)
    raise RESTError.new(:code => response.code, :message => response.message)
  end

  def self.handle_rest_response(response)
    raise_rest_error(response) unless response.is_a?(Net::HTTPSuccess)
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

  def self.path_with_params(path, params = {})
    path_with_params = path.clone
    unless params.empty?
      params.each do |key, value|
        if path_with_params=~/__#{key}__/
          path_with_params.sub!(/__#{key}__/, value.to_s)
          params.delete(key)
        end
      end
    end
    return path_with_params, params
  end

  def self.http_get_request(path, params = {})
    params.merge!(:api_key => self.config.api_key) unless self.config.api_key == ''
    path = (params.size > 0) ? "#{path}?#{params.to_http_str}" : path
    http = Net::HTTP.new(self.config.api_host, self.config.api_port)
    response = http.get(path, http_header)
    handle_rest_response(response)
    JSON.parse(response.body)
  end

  def self.http_post_request(iknow_auth, path, params = {})
    self.api_key_required
    params.merge!(:api_key => self.config.api_key)
    case iknow_auth.mode
    when :oauth 
      response = iknow_auth.auth_token.post(path, params, http_header)
      handle_rest_response(response)
      response.body
    when :basic_auth
      begin
        response = iknow_auth.auth_token.post(self.config.iknow_api_base_url + path, params)
        response.body
      rescue WWW::Mechanize::ResponseCodeError => e
        raise RESTError.new(:code => e.response_code, :message => e.to_s)
      end
    end
  end

  def self.http_delete_request(iknow_auth, path, params = {})
    self.api_key_required
    params.merge!(:api_key => self.config.api_key)
    case iknow_auth.mode
    when :oauth
      response = iknow_auth.auth_token.delete(path, params.stringfy_keys!.stringfy_values!)
      handle_rest_response(response)
    when :basic_auth
      begin
        iknow_auth.auth_token.delete(self.config.iknow_api_base_url + path, params.stringfy_keys!)
      rescue WWW::Mechanize::ResponseCodeError => e
        raise RESTError.new(:code => e.response_code, :message => e.to_s)
      end
    end
  end

  private_class_method :raise_rest_error, :handle_rest_response, :http_header,
                       :path_with_params, :http_get_request, :http_post_request, :http_delete_request

end