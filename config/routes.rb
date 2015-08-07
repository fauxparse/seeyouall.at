Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: "users/registrations" }

  resources :events do
    post "check", on: :collection

    get :register, to: "registrations#new"
    post :register, to: "registrations#create"

    resource  :registration, only: [:show, :update]
    resources :registrations, shallow: true
    resource  :timetable
    resources :activities
    resources :activity_types, only: [:create, :update, :destroy]
    resources :time_slots, only: [:create, :destroy]
    resources :scheduled_activities, only: [:create, :update, :destroy]
  end

  root to: "events#index"
end
