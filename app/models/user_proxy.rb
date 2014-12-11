class UserProxy
  
  include Wisper::Publisher
  
  include Mongoid::Document
  include Mongoid::Timestamps  
  
  field :name, type: String
  field :email, type: String
  field :access_token, type: String
  
  belongs_to :kiwi
  
  def self.set_up_user(access_token: nil)
    user = get_user_from_id_service(access_token: access_token)
    proxy = self.find_or_create(access_token: access_token, user: user)
    proxy
  end
  
  def self.find_or_create(access_token: nil, user: nil)
    up = self.where(name: user.username).first
    if up
      up.add_attrs(access_token: access_token)
    else
      up = self.new.add_attrs(user: user, access_token: access_token)
    end
    up
  end
    
  def self.get_user_from_id_service(access_token: nil)
    user_store = EvernoteOAuth::Client.new(token: access_token).user_store
    user_store.getUser
  end
    
  
  def add_attrs(user: nil, access_token: nil)
    self.name = user.username if user
    self.access_token = access_token
    save
    self
  end
  
  def get_user
    user_store = EvernoteOAuth::Client.new(token: self.access_token).user_store
    user_store.getUser
  end
  
  
end