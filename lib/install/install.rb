source_root = File.expand_path('../templates', __FILE__)

say "Generate StaticController"
generate "controller", "static index --skip-test-framework --skip-assets --skip-helper --skip-routes"

# TODO: Copy content to index view

say "Add default RailsUI routing and engine"
content = <<-RUBY
  if Rails.env.development? || Rails.env.test?
    mount Railsui::Engine, at: "/railsui"
  end

  scope controller: :static do

  end

  root to: "static#index"
RUBY

insert_into_file "#{Rails.root}/config/routes.rb", "#{content}\n", after: "Rails.application.routes.draw do\n"

if Rails.root.join("app/views/shared").exist?
  say "app/views/shared already exists. Files can't be copied. Refer to the gem source for reference."
else
  say "Adding shared partials"
  directory "#{__dir__}/shared", Rails.root.join("app/views/shared")
end

if (app_layout_path = Rails.root.join("app/views/layouts/application.html.erb")).exist?
  say "Add meta tag partial"
  insert_into_file(
    app_layout_path.to_s,
    %(\n    <%= render "shared/meta" %>),
    before:/\s*<\/head>/
  )

  say "Add flash and nav partials"
  insert_into_file(
    app_layout_path.to_s,
    %(
    <%= render "shared/flash" %>
    <%= render "shared/nav" %>
    ),
    after:"<body>"
  )
end
