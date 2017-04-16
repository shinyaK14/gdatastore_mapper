Rails.application.routes.draw do
  root "authors#index"

  resources :authors, shallow: true, except: :show do
    resources :books
  end
end
