Railsui::Engine.routes.draw do
  resource :admin, only: :show
  resource :configuration, only: [:create, :update]
  resource :systems, only: :show
  resource :routes, only: :show
  get :delete_page, to: "configurations#delete_page"

  namespace :systems do
    get :authentication
    get :components
    get :content
    get :flash
    get :forms
    get :icons
    get :mailers
    get :pages
    get :scaffolds

    namespace :authentication do
      get :confirmation
      get :edit
      get :overview
      get :change_password
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
      get :action_text
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
      get :datalists
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
      get :devise
      get :layout
      get :minimal
      get :promotion
      get :transactional
    end
  end

  scope controller: :page do
    get :index
    get :start
  end

  root to: "admin#show"
end
