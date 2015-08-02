Rails.application.routes.draw do
  get 'timetables/show'

  get 'timetables/edit'

  devise_for :users, controllers: { registrations: "users/registrations" }

  resources :events do
    post "check", on: :collection

    resource :timetable
  end

  root to: "events#index"
end
