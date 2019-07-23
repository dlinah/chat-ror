Rails.application.routes.draw do
  resources :app, only: [ :show, :update, :create] do
    resources :chat, only: [:show, :update, :create] do
      resources :message, only: [:show, :update, :create]
    end
  end
    # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
