require 'timeout'

class Smartfm::RestClient::Base

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
      if args[0].is_a?(Smartfm::Auth)
        path, params = path_with_params(self.path(action), args[1])
        http_get_with_auth(auth(args[0]), path, params)
      else
        path, params = path_with_params(self.path(action), args[0])
        http_get(path, params)
      end
    when :post
      path, params = path_with_params(self.path(action), args[1])
      http_post(auth(args[0]), path, params)
    when :delete
      path, params = path_with_params(self.path(action), args[1])
      http_delete(auth(args[0]), path, params)
    end
  end

  private

  def self.config; Smartfm::Config end

  def self.auth(auth)
    if auth.is_a?(Smartfm::Auth)
      auth
    else
      raise ArgumentError.new("Authorized Smartfm::Auth instance is required")
    end
  end

  def self.api_key_required
    raise ArgumentError.new("smart.fm API key is required") if self.config.api_key == ''
  end

  def self.raise_rest_error(response)
    raise RESTError.new(:code => response.code, :message => response.message)
  end

  def self.handle_rest_response(response, format)
    raise_rest_error(response) unless response.is_a?(Net::HTTPSuccess)
    case format
    when :json
      handle_json_response(response.body)
    when :nothing
      # success => nothing / failure => json error
      begin
        handle_json_response(response.body)
      rescue Exception => e
        e.is_a?(RESTError) ? raise(e) : :success
      end
    else  
      begin
        handle_json_response(response.body)
      rescue Exception => e
        e.is_a?(RESTError) ? raise(e) : response.body
      end
    end
  end

  def self.handle_json_response(json_response)
    hash = JSON.parse(json_response)
    unless (hash['error'].nil? rescue :success) # success response may be Array, not Hash.
      if hash['error']['code'] == 404
        return nil
      else
        raise RESTError.new(:code => hash['error']['code'], :message => hash['error']['message'])
      end
    end
    hash
  end

  def self.http_header
    @@http_header ||= {
      'User-Agent' => "#{self.config.application_name} v#{Smartfm::Version.to_version} [#{self.config.user_agent}]",
      'Accept'     => 'text/x-json',
      'X-smartfm-Gem-Client'         => self.config.application_name,
      'X-smartfm-Gem-Client-Version' => self.config.application_version,
      'X-smartfm-Gem-Client-URL'     => self.config.application_url,
    }
  end

  def self.http_connect
    http = Net::HTTP.new(self.config.api_host, self.config.api_port)
    http.start do |conn|
      request, format = yield
      begin
        timeout(self.config.timeout) do
          response = conn.request(request)
          handle_rest_response(response, format)
        end
      rescue
        raise RESTError.new(:code => 408, :message => "smart.fm Gem Timeout (#{self.config.timeout} [sec])")
      end
    end
  end

  def self.path_with_params(path, params = {})
    path_with_params = path.clone
    unless params.empty?
      params.each do |key, value|
        if path_with_params=~/__#{key}__/
          path_with_params.sub!(/__#{key}__/, URI.encode(value.to_s))
          params.delete(key)
        end
      end
    end
    return path_with_params, params
  end

  def self.http_get(path, params = {})
    http_connect do
      params.merge!(:api_key => self.config.api_key) unless self.config.api_key == ''
      path = (params.size > 0) ? "#{path}?#{params.to_http_str}" : path
      get_req = Net::HTTP::Get.new(path, http_header)
      [get_req, :json]
    end
  end

  def self.http_get_with_auth(auth, path, params = {})
    params.merge!(:api_key => self.config.api_key) unless self.config.api_key == ''
    path = (params.size > 0) ? "#{path}?#{params.to_http_str}" : path
    case auth.mode
    when :oauth
      response = auth.auth_token.get(path, http_header)
      handle_rest_response(response, :json)
    when :basic_auth
      http_connect do
        get_req = Net::HTTP::Get.new(path, http_header)
        get_req.basic_auth(auth.account.username, auth.account.password)
        [get_req, :json]
      end
    end
  end

  def self.http_post(auth, path, params = {})
    api_key_required
    params.merge!(:api_key => self.config.api_key)
    case auth.mode
    when :oauth
      response = auth.auth_token.post(path, params, http_header)
      handle_rest_response(response, :text)
    when :basic_auth
      http_connect do
        post_req = Net::HTTP::Post.new(path, http_header)
        post_req.body = params.to_http_str
        post_req.basic_auth(auth.account.username, auth.account.password)
        [post_req, :text]
      end
    end
  end

  def self.http_delete(auth, path, params = {})
    api_key_required
    params.merge!(:api_key => self.config.api_key)
    path = "#{path}?#{params.to_http_str}"
    case auth.mode
    when :oauth
      response = auth.auth_token.delete(path, params.stringfy_keys!.stringfy_values!)
      handle_rest_response(response, :nothing)
    when :basic_auth
      http_connect do
        delete_req = Net::HTTP::Delete.new(path, http_header)
        delete_req.basic_auth(auth.account.username, auth.account.password)
        [delete_req, :nothing]
      end
    end
  end

end