Rails.application.routes.draw do
  
    root :to => "home#show"
    
    get '/auth/:provider/callback' => 'login#callback'
    
    resources :notes
    
    resources :payees do
      resources :accounts
    end
    
    
    resources :payments
    
end
