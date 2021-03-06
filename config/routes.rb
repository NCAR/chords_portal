Rails.application.routes.draw do
  # devise_for :users
  devise_for :users, controllers: {
    sessions: 'users/sessions'
  }

  # send logged in user to the dashboard
  authenticated :user do
    root to: 'dashboard#index', as: :authenticated_root
  end

  root to: 'dashboard#index', constraints: lambda { |request| Profile.first && !Profile.first.secure_data_viewing }
  root to: 'about#index', as: :unauthenticated_root


  namespace :api, :defaults => {format: 'json'} do
    namespace :v1 do
      resources :sites
      resources :data, only: [:index, :show]
    end
  end


  get '/bulk_download'            , to: 'bulk_download#index'
  get '/bulk_download/download'  , to: 'bulk_download#download'
  delete '/bulk_download/delete'  , to: 'bulk_download#destroy'
  post '/bulk_download'           , to: 'bulk_download#create'


  resources :dashboard
  resources :data, only: :index
  # resources :bulk_download, only: [:index, :create, :destroy, :send_file]
  resources :influxdb_tags
  resources :linked_data, only: [:index, :edit, :update, :show]
  resources :measured_properties
  resources :site_types
  resources :topic_categories
  resources :units



  



  resources :about, only: :index do
    collection do
      get :data_urls
    end
  end

  resources :instruments do
    member do
      get :live
    end

    collection do
      get :duplicate
      get :live
      get :simulator
    end
  end

  resources :measurements, except: [:index, :show, :new, :create, :update, :edit, :destroy] do
    collection do
      get  :url_create
      post :delete_test
    end
  end

  resources :monitor do
    collection do
      get :live
    end
  end

  resources :profiles, only: [:index, :create, :backup, :restore] do
    collection do
      get :export_configuration
      get :import_configuration
      post :import_configuration

      get :export_influxdb
      get :import_influxdb
      post :import_influxdb

      post :test_sending_email
    end
  end

  resources :sites do
    collection do
      get :map
      get :map_markers_geojson
    end

    member do
      get :map_balloon_json
    end
  end

  resources :users do
    get :assign_api_key
  end

  resources :vars do
    collection do
      get :autocomplete_measured_property_label
      get :autocomplete_unit_name
    end
  end

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
