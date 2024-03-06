Rails.application.routes.draw do
  root "jobs#index"
  resources :jobs do
    member do
      post :edit
    end
  end
end
