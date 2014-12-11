class LoginController < ApplicationController
  rescue_from OAuth::Unauthorized, :with => Proc.new{redirect_to root_path}

  def callback
    auth = IdentityAdapter.new
    auth.subscribe(self)
    auth.get_access(token: request.env['omniauth.auth']['credentials']['token'])
  end

  def oauth_failure
    redirect_to root_path
  end

  def logout
    session.clear
    redirect_to root_path
  end

  def valid_authorisation(user_proxy)
    session[:user_proxy] = {proxy_id: user_proxy.id.to_s}
    redirect_to root_path
  end


end
