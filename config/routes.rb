Railsui::Engine.routes.draw do
  resource :admin, only: :show
  resource :configuration, only: [:create, :update]
  resource :docs, only: :show
  resource :systems, only: :show

  namespace :systems do
    get :forms
    get :components
    get :content
    get :scaffolds
    get :authentication
    get :marketing
    get :flash
    get :icons

    namespace :authentication do
      get :overview
      get :signup
      get :signin
      get :reset_password
      get :edit
      get :confirmation
      get :unlocks
    end

    namespace :content do
      get :typography
      get :tables
      get :images
    end

    namespace :forms do
      get :inputs
      get :input_groups
      get :selects
      get :checkboxes_and_radios
      get :layout
      get :validation
    end

    # namespace :marketing do
    #   get :ctas
    #   get :footers
    #   get :headers
    #   get :longform
    # end

    namespace :components do
      get :accordions
      get :alerts
      get :badges
      get :breadcrumbs
      get :buttons
      get :cards
      get :dropdowns
      get :flash
      get :modals
      get :navigation
      get :pagination
      get :popovers
      get :tabs
      get :toasts
      get :tooltips
    end
  end

  namespace :docs do
    get :installation
    get :configuration
    get :css_frameworks, path: "css-frameworks"
  end

  root to: "admin#show"
end
