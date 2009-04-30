class Smartfm::Like < Smartfm::Base
  ATTRIBUTES = [:id, :type, :title, :description, :href, :favorite, :user]
  attr_reader *ATTRIBUTES

  def initialize(params)
    @id          = params[:id]
    @type        = params[:user]
    @title       = params[:title]
    @description = params[:description]
    @href        = params[:href]
    @favorite    = params[:favorite]
    @user        = self.deserialize(params[:user], :as => Smartfm::User)
  end

end