class Smartfm::Like < Smartfm::Base
  ATTRIBUTES = [:id, :type, :title, :description, :href, :favorite, :user]
  attr_reader *ATTRIBUTES
  
  include Smartfm::PrivateContent

  def self.rest_client; Smartfm::RestClient::Like; end
  def rest_client; self.class.rest_client; end

  def initialize(params)
    @id          = params[:id].to_i
    @type        = params[:user]
    @title       = params[:title]
    @description = params[:description]
    @href        = params[:href]
    @favorite    = params[:favorite]
    @user        = self.deserialize(params[:user], :as => Smartfm::User)
  end

end