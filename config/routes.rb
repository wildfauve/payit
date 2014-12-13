Rails.application.routes.draw do
  
    root :to => "home#show"
    
    get '/auth/:provider/callback' => 'login#callback'
    
    resources :notes
    
    resources :payees do
      resources :accounts
    end
    
    
    resources :payments do
      collection do
        get 'filter_list'
        post 'filter_search'
      end
      member do
        put 'paid'
      end
    end
    
    
end
