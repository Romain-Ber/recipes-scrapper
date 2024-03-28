Rails.application.routes.draw do
  devise_for :users
  root to: "pages#home"
  resources :posts, only: [:index, :show, :create] do
    resources :comments, only: [:create]
  end
end
