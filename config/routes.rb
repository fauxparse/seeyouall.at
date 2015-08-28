Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: "users/registrations" }

  resources :users

  resources :events do
    post :check, on: :collection
    post :check, on: :member

    get :register, to: "registrations#new"
    post :register, to: "registrations#create"

    resource  :registration, only: [:show, :update] do
      get :summary
    end
    resource  :itinerary do
      post :check
    end
    resources :registrations, shallow: true
    resource  :timetable
    resources :activities
    resources :activity_types, only: [:create, :update, :destroy]
    resources :time_slots, only: [:create, :destroy]
    resources :scheduled_activities, only: [:create, :update, :destroy]
    resources :locations
    resources :payments do
      post :approve, on: :collection
      post :decline, on: :collection
    end
    resource  :account
    resource  :map, only: :show
  end

  root to: "events#index"
end
