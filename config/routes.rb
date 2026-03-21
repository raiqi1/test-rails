Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  mount Rswag::Ui::Engine => "/api-docs"
  mount Rswag::Api::Engine => "/api-docs"

  resources :restaurants do
    resources :menu_items, only: [:index, :create]
  end

  resources :menu_items, only: [:update, :destroy]
end
