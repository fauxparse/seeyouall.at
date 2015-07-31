Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: "users/registrations" }

  resources :events do
    post "check", on: :collection
  end

  root to: "events#index"
end
