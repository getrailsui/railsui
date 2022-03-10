Railsui::Engine.routes.draw do
  resource :admin, only: :show
  resource :configuration, only: :create
  resource :docs, only: :show
  resource :systems, only: :show

  namespace :systems do
    get :layout

    get :forms
    get :components
    get :utilities
    get :content

    namespace :content do
      get :typography
      get :tables
      get :images
    end

    namespace :forms do
      get :inputs
      get :input_groups
      get :selects
      get :boxes_and_radios
      get :layout
      get :validation
      get :scaffolding
    end
  end

  namespace :docs do
    get :installation
    get :configuration
    get :css_frameworks, path: "css-frameworks"
  end

  root to: "admin#show"
end
