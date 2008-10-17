module IknowOauthSystem

  protected

  def require_iknow_oauth
    unless iknow_username_exists?
      redirect_to(:controller => 'iknow_oauth', :action => 'index') 
      return false
    end

    iknow_oauth_token = IknowOauthToken.find_by_username(session[:iknow_username])
    unless iknow_oauth_token
      redirect_to(:controller => 'iknow_oauth', :action => 'new_request')
      return false
    end

    true
  end

  private

  def iknow_username_exists?
    !session[:iknow_username].blank?
  end

end