module ApplicationHelper
  
  def account_selector
    Account.all.collect {|a| ["#{a.payee.name} -> #{a.name}", a.id]}
  end
    
end
