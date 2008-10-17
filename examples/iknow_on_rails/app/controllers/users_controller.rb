class UsersController < ApplicationController

  def index
    unless params[:iknow_username].blank?
      @user = Iknow::User.find(params[:iknow_username])
      flash[:notice] = "404 User Not Found" unless @user
    end
  end

end
