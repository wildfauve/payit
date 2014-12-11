class Account
  
  include Wisper::Publisher
  
  include Mongoid::Document
  include Mongoid::Timestamps  
  
  belongs_to :payee
  
  has_many :payments
  
  field :name, type: String

  def create_me(acct: nil)
    update_attrs(acct: acct)
    self
  end
  
  def update_me(acct: nil)
    update_attrs(acct: acct)
    self
  end
  
  
  def update_attrs(acct: nil)
    self.name = acct[:name]
  end  
  
end