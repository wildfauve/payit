class Payee
  
  include Wisper::Publisher
  
  include Mongoid::Document
  include Mongoid::Timestamps  
  
  has_many :accounts
  
  field :name, type: String

  def create_me(payee: nil)
    update_attrs(payee: payee)
    self.save
    publish(:successful_payee_save_event, self)
  end
  
  def update_me(payee: nil)
    update_attrs(payee: payee)
    self.save
    publish(:successful_payee_save_event, self)
  end
  
  
  def update_attrs(payee: nil)
    self.name = payee[:name]
  end  
  
  def create_acct(acct: nil)
    acct = Account.new.create_me(acct: acct)
    self.accounts << acct
    self.save
    publish(:successful_account_save_event, self)
  end

  def update_acct(id: nil, acct: nil)
    raise if !id
    acct = self.accounts.find(id).update_me(acct: acct)
    self.save
    publish(:successful_account_save_event, self)
  end

  
end