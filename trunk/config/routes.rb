Adhub::Application.routes.draw do
  resources :ad_requests do
    post :shown, :clicked, :on=>:member
  end

  resources :parties do
    get :autocomplete_search, :on=>:collection
    post :archived, :on=>:member
  end

  resources :contracts do
    post :stop, :on=>:member
    put :renewal, :on=>:member
  end
  
  match '/members/my_account',:controller=>'members',:action=>'edit',:format=>:html

  resources :members do 
    get 'active', :on=>:member
    get 'check_email', 'forget_password_form', :on=>:collection
    post :resend_active_email, :on=>:collection
    post :forget_password_form,:on=>:collection
    get :modify_passwd,:on=>:collection
    post :update_passwd,:on=>:member
    post :supplement,:on=>:member
    get :faces,:on=>:member 
  end
  
  namespace :admin do
    resources :parties do
      post :save_account,:on=>:member
      resources :contracts
    end

    resources :contracts do
      put :renewal, :on=>:member
      post :stop, :on=>:member
    end
    resources :members do
      member do
        post :locked_Or_unlocked
        post :supplement
        get :show_records     
        get :faces
      end     
      get :autocomplete_search, :on=>:collection
    end

    resources :advertisements do
      post :approve, :on=>:member
    end
    
    resources :ad_containers do
      post :approve, :on=>:member     
    end
    
    resources :account_transactions

    resources :cash_claims
    
    resources :content_categories
    
    resources :sdks do
      get :next_step,:on=>:member
      post :upload_sdk,:on=>:member
    end
    match '/', :controller=>'members', :action=>'index'
  end

  namespace :my_company do
    resources :parties do
      get :show_account_transactions,:on=>:collection
    end
    resources :members do
      post :lock, :on=>:collection
      post :unlock, :on=>:collection
      post :reset_passwd, :on=>:collection
    end
  end
  
  namespace :ad_owner do
    resources :campaigns do
      post 'stop', 'execute', 'submit', 'set_budget', :on=>:member
      get 'budgets', :on=>:collection
      get 'budget', :on=>:member
      resources :publish_policies do
        post 'stop',:on=>:member
        post 'execute',:on=>:member
      end
    end
    
    match '/', :controller=>'console', :action=>'index'
    match '/console/select_ad_owner', :controller=>'console', :action=>'select_ad_owner'
    match '/ad_resources/:ad_format/:action(.:format)', :controller=>'ad_resources'

    resources :ad_resources
    
    resources :advertisements do
      post :submit_approve,:on=>:member
      post :revoke, :on=>:member
      post :stop, :on=>:member
      post :execute,:on=>:member
      
      resources :publish_policies do
         get :step_2,:on=>:member
         get :step_3,:on=>:member
         get :search,:on=>:member
         get :judge_successful_step_2,:on=>:member
         get :select_content_categories,:on=>:member
         post :stop,:on=>:member
         post :execute,:on=>:member
         post :decrease_ad_container,:on=>:member
         post :increase_ad_container,:on=>:member
         post :notice_to_price,:on=>:member
         post :save_step_3,:on=>:member
         post :save_content_categories,:on=>:member
      end
    end

    resource :report do
      get 'summary', 'daily', :on=>:member
    end
  end

  namespace :agent do
    match '/', :controller=>'console', :action=>:index
  end

  namespace :publisher do
    resources :black_lists
    resources :prices
    resources :publish_policies do
      get :ad_detail, :on=>:collection
    end

    resources :ad_containers do
       post :submission,:on=>:member
       get :show_identity,:on=>:member
    end

    resource :report do 
      get 'summary', 'daily', :on=>:member
    end
     
    resources :bank_accounts do 
       get :show_ex ,:on=>:collection 
       post :send_dynamic_pass ,:on=>:collection 
    end
    
    resources :cash_claims

    match '/', :controller=>'console', :action=>:index
  end

  namespace :member do
    resource :cash_claims
  end
  
  scope '/target/:target_type/:target_id'  do
    resources :approve_logs
  end
  
  resources :sdks do
    collection do
      get :sdks_list
    end
  end
  match 'sdks/:os_type/download',:controller=>'sdks',:action=>'download'
  
  resource :session 
  

  match '/', :controller=>'sites', :action=>'index', :as=>'main'
  match '/static/:action', :controller=>'sites'
  
  
  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => "welcome#index"

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
