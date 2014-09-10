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

    resources :orders

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
end
