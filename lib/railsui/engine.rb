# frozen_string_literal: true
module Railsui
   class Engine < ::Rails::Engine
      isolate_namespace Railsui

      config.before_initialize do
        Railsui.config = Railsui::Configuration.load!
      end

      initializer "railsui.theme_helper" do
        ActiveSupport.on_load :action_controller do
          helper Railsui::ThemeHelper
        end
      end

      initializer 'railsui.setup' do |app|
        if Rails.env.development?
          config.assets.precompile << "railsui_manifest.js"
        end
      end

      initializer "railsui.assets.precompile" do |app|
        app.config.assets.paths << root.join("builds").to_s
        app.config.assets.precompile << "railsui/application.css"
        app.config.assets.precompile << %w[*.svg]
      end
   end
 end
