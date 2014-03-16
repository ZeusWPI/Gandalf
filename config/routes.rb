Isengard::Application.routes.draw do
  devise_for :partners
  devise_for :users
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products
  resources :events do
    member do
      get 'export_status'
      post 'generate_export'
      post 'toggle_registration_open'
    end

    resources :zones
    resources :access_levels do
      resources :zones
      member do
        get 'toggle_visibility'
      end
    end
    resources :role_names
    resources :registrations do
      member do
        get 'resend'
        get 'info'
      end

      collection do
        post 'basic'
        post 'advanced'
        post 'upload'
        post 'email'
      end
    end

    member do
      get 'statistics'
      get 'scan'
      post 'check_in'
    end

    resources :periods

    resources :partners do
      member do
        get 'sign_in', to: 'sign_in#sign_in_partner'
        get :resend
        post :confirm
      end
      collection do
        post 'upload'
      end
    end
  end

  patch "events/:event_id/access_level/:access_level_id/set_zones", to: "access_levels#set_zones", as: "set_zones_for_access_level"

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
