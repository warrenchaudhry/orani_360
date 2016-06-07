Rails.application.routes.draw do

  mount Ckeditor::Engine => '/ckeditor'
  root :to => 'main#index'
  namespace :admin do
    get '/' => 'dashboards#index'
    resources :dashboards, only: [:index]
    resources :customers
    resources :sessions
    resources :users
    resources :pages
    get 'registrations/:id/approve', to: 'registrations#pre_approval', as: 'pre_approve_registration'
    put 'registrations/:id/approve', to: 'registrations#approve', as: 'approve_registration'
    get 'registrations/:id/reject', to: 'registrations#pre_reject', as: 'pre_reject_registration'
    put 'registrations/:id/reject', to: 'registrations#reject', as: 'reject_registration'
    resources :registrations

    get 'login' => 'sessions#new', :as => :login
    delete 'logout' => 'sessions#destroy', :as => :logout
  end
  resources :registrations, only: [:new, :show, :create]
  get '/(:page_url)', to: 'main#pages', constraints: UrlConstraint.new
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
