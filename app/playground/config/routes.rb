Rails.application.routes.draw do
  root "landing#show"
  post "preview", to: "landing#preview", as: :landing_preview

  resources :components, param: :name, only: %i[ index show ] do
    post :preview, on: :member
  end

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check
end
