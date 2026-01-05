Rails.application.routes.draw do
  # LIFF (User-facing)
  namespace :liff do
    root to: "products#index"
    resource :session, only: [ :create ]
    resources :cart_items, only: [ :create, :update, :destroy ], param: :product_id
    resource :cart, only: [ :show ]
    resource :checkout, only: [ :show ]
    resources :orders, only: [ :create ] do
      member do
        get :complete
      end
    end
  end

  # Admin
  namespace :admin do
    root to: "orders#index"
    resources :products
    resources :orders, only: [ :index, :show ] do
      member do
        patch :update_status
      end
    end
  end

  # Health check
  get "up" => "rails/health#show", as: :rails_health_check

  # PWA
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  # Root redirect to LIFF
  root to: redirect("/liff")
end
