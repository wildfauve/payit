class IdentityAdapter
  
  include Wisper::Publisher
  
  def get_access(token: nil)
    @user_proxy = UserProxy.set_up_user(access_token: token)
    publish(:valid_authorisation, @user_proxy)
  end
    
  
end