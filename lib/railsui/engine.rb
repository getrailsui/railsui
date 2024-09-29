# loads all dependencies in .gempspec
Gem.loaded_specs['railsui'].dependencies.each do |d|
  require d.name
 end

 module Railsui
   class Engine < ::Rails::Engine
      isolate_namespace Railsui
      engine_name = "railsui"

      config.autoload_once_paths << File.expand_path("../../app/helpers", __dir__)

      initializer "railsui.load_helpers", before: :set_autoload_paths do |app|
        app.config.autoload_once_paths << File.expand_path("../../app/helpers", __dir__)
      end

      config.to_prepare do
        Railsui::Engine.config.host_app_stylesheet = 'application'
      end

      config.app_generators do |g|
        g.templates.unshift File.expand_path("../templates", __dir__)
        g.scaffold_stylesheet false
      end

      config.before_initialize do
        Railsui.config = Railsui::Configuration.load!
      end

      initializer 'railsui.setup' do |app|
        if Rails.env.development?
         config.assets.precompile << "railsui_manifest.js"
       end
      end

      initializer "railsui.mailer_helper", after: :set_autoload_paths do
        ActiveSupport.on_load :action_mailer do
          require_relative "../../app/helpers/railsui/mail_helper"
          helper Railsui::MailHelper
        end
      end

      initializer "railsui.assets.precompile" do |app|
        app.config.assets.paths << root.join("builds").to_s
        app.config.assets.precompile << "railsui/application.css"
      end
   end
 end
