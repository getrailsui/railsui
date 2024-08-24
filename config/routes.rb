Railsui::Engine.routes.draw do
  resource :admin, only: :show
  resource :configuration, only: [:create, :update] do
    get 'reset_colors', on: :collection
  end
  resource :systems, only: :show
  resource :routes, only: :show
  resources :mailers, only: [:index, :show]
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
      get :overview

      namespace :devise do
        get :confirmation
        get :edit
        get :overview
        get :change_password
        get :reset_password
        get :signin
        get :signup
        get :unlocks
      end

      namespace :static do
        get :confirmation
        get :edit
        get :overview
        get :change_password
        get :reset_password
        get :signin
        get :signup
        get :unlocks
      end
    end

    namespace :content do
      get :image
      get :table
      get :typography
    end

    namespace :forms do
      get :action_text
      get :checkbox
      get :input_group
      get :input
      get :layout
      get :radio
      get :select
      get :switch
      get :validation
    end

    namespace :components do
      get :accordion
      get :alert
      get :badge
      get :breadcrumb
      get :button
      get :card
      get :datalist
      get :dropdown
      get :flash
      get :modal
      get :navigation
      get :pagination
      get :tab
      get :toast
      get :tooltip
    end

    namespace :mailers do
      get :overview
      get :devise
      get :layout
      get :minimal
      get :promotion
      get :transactional
    end
  end

  scope controller: :default do
    get :index
    get :start
  end

  root to: "admin#show"
end
