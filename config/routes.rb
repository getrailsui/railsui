Railsui::Engine.routes.draw do
  resource :admin, only: :show
  resource :configuration, only: :create
  resource :docs, only: :show

  namespace :docs do
    get :installation
    get :configuration
  end

  root to: "admin#show"
end
