Rails.application.routes.draw do
  get 'options/new'

  get 'option/new'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root "items#index"
  resources :categories
  resources :items
end
