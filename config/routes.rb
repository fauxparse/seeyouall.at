Rails.application.routes.draw do
  get 'timetables/show'

  get 'timetables/edit'

  devise_for :users, controllers: { registrations: "users/registrations" }

  resources :events do
    post "check", on: :collection

    resource :timetable
    resources :time_slots, only: [:create, :destroy]
    resources :scheduled_activities, only: [:create, :update, :destroy]
  end

  root to: "events#index"
end
