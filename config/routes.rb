Railsui::Engine.routes.draw do
  resource :admin, only: :show
  resource :configuration, only: :create
  resource :docs, only: :show
  resource :design_system, only: :show, path: "design-system"

  namespace :design_system do
    get :layout
    get :content
    get :forms
    get :components
    get :utilities
  end

  namespace :docs do
    get :installation
    get :configuration
    get :css_frameworks, path: "css-frameworks"
  end

  root to: "admin#show"
end
