class IknowOauthController < ApplicationController

  def index; end

  def new_request
    request_token = IknowOauthToken.new_request_token

    session[:iknow_username]          = params[:iknow_username]
    session[:request_token]           = request_token
    session[:redirect_url_after_auth] = params[:redirect_url_after_auth] || request.referer

    if request_token
      redirect_to(request_token.authorize_url)
    else
      raise RuntimeError.new("Failed to get a iKnow! Request Token") 
    end
  end

  def callback
    AuthToken.establish_auth_token(session[:iknow_username], session[:request_token])
    redirect_to(session[:redirect_url_after_auth])
  end

end
