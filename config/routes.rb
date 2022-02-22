Railsui::Engine.routes.draw do
  resource :admin, only: :show
  resource :configuration, only: :create

  resource :docs do
    get :installation
    get :configuration
    get :upgrading
  end

  root to: "admin#show"
end
