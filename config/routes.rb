TrainingDeals::Application.routes.draw do
  
  resources :users
  resources :sessions, only: [:new, :create, :destroy]
  resources :training_methods
  resources :durations
  root  'static_pages#home'
  match '/signup',          to: 'users#new',                via: 'get'
  match '/signin',          to: 'sessions#new',             via: 'get'
  match '/signout',         to: 'sessions#destroy',         via: 'delete'
  match '/about',           to: 'static_pages#about',       via: 'get'
  match '/contact',         to: 'static_pages#contact',     via: 'get'
  match '/admin_menu',      to: 'static_pages#admin_menu',  via: 'get'
  match '/framework',       to: 'admin_pages#framework',    via: 'get'
  match '/users_menu',      to: 'admin_pages#users_menu',   via: 'get'
  match '/vendors_menu',    to: 'admin_pages#vendors_menu', via: 'get'
  match '/feedback',        to: 'admin_pages#feedback',     via: 'get'
  match '/billings',        to: 'admin_pages#billings',     via: 'get'
  match '/text_editor',     to: 'admin_pages#text_editor',  via: 'get'


  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
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

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
