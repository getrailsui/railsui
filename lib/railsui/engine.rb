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
          helper Railsui::ComponentHelper
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
      
      config.to_prepare do
        # Eagerly load base component to ensure it's available
        base_component_path = Rails.root.join("app/components/railsui/base_component.rb")
        if File.exist?(base_component_path)
          begin
            require_dependency base_component_path
          rescue LoadError => e
            Rails.logger.debug "Rails UI: Could not load #{base_component_path}: #{e.message}"
          end
        end
      end
   end
 end
