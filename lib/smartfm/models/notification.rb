class Smartfm::Notification < Smartfm::Base
  ATTRIBUTES = [:type, :message, :recipient, :sender, :context]
  READONLY_ATTRIBUTES = [:type, :recipient, :sender, :context]
  attr_accessor *(ATTRIBUTES - READONLY_ATTRIBUTES)
  attr_reader   *READONLY_ATTRIBUTES

  include Smartfm::PrivateContent

  def self.rest_client; Smartfm::RestClient::Notification; end
  def rest_client; self.class.rest_client; end

  def initialize(params)
    @type      = params[:type]
    @message   = params[:message]
    @recipient = params[:recipient]
    @sender    = params[:sender]
    @context   = params[:context]
  end

  protected

  def to_post_data
    {:message => self.message}
  end

end