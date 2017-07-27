class Account
  
  include Wisper::Publisher
  
  include Mongoid::Document
  include Mongoid::Timestamps  
  
  belongs_to :payee
  
  has_many :payments
  
  field :name, type: String
  field :account_number, type: String
  field :particulars, type: String
  field :code, type: String  
  field :reference, type: String

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
    self.account_number = acct[:account_number]    
    self.particulars = acct[:particulars] 
    self.code = acct[:code]
    self.reference = acct[:reference]
    save
  end  
  
end