Railsui::Engine.routes.draw do
  resource :admin, only: :show
  resource :configuration, only: [:create, :update]
  resource :docs, only: :show
  resource :systems, only: :show

  namespace :systems do
    get :authentication
    get :components
    get :content
    get :flash
    get :forms
    get :icons
    get :mailers
    get :marketing
    get :scaffolds

    namespace :authentication do
      get :confirmation
      get :edit
      get :overview
      get :reset_password
      get :signin
      get :signup
      get :unlocks
    end

    namespace :content do
      get :images
      get :tables
      get :typography
    end

    namespace :forms do
      get :checkboxes_and_radios
      get :input_groups
      get :inputs
      get :layout
      get :selects
      get :validation
    end

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

    namespace :mailers do
      get :layout
      get :minimal
      get :promotion
      get :transactional
    end
  end

  namespace :docs do
    get :configuration
    get :css_frameworks, path: "css-frameworks"
    get :installation
  end

  root to: "admin#show"
end
