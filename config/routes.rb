Timesheet::Application.routes.draw do
  resources :schools


  resources :timelogs 
  resources :users, only: [:index, :remove, :view, :edit, :new, :create, :update]

  get "welcome/index"

  devise_for :users
  
  devise_for :users, :path => "auth", :path_names => { :sign_in => 'login', :sign_out => 'logout', :password => 'secret', :confirmation => 'verification', :unlock => 'unblock', :registration => 'register', :sign_up => 'cmon_let_me_in' }

  match 'studentlogin' => 'timelogs#student'
  match 'studentLogin' => 'timelogs#student'
  
  match 'users/delete/:id' => 'users#remove', :via => :delete, :as => :admin_remove_user
  match 'users/view/:id' => 'users#view', :via => :get, :as => :admin_view_user
  match 'users/edit/:id' => 'users#edit', :via => :get, :as => :admin_edit_user
  match 'users/update/:id' => 'users#save', :va => :put, :as => :admin_update_user
  match 'users/new' => 'users#new', :via => :get, :as => :admin_new_user
  match 'users/create' => 'users#create', :via => :post, :as => :admin_create_user
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
  root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
