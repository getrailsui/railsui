require_dependency "railsui/application_controller"

module Railsui
  class ConfigurationsController < ApplicationController
    def create
      config_params = configuration_params.to_h
      previous_build_mode = Railsui::Configuration.load!.build_mode

      Railsui::Configuration.update(config_params)

      # Handle build mode changes
      if config_params[:build_mode] && config_params[:build_mode] != previous_build_mode
        # Build mode changed - regenerate assets appropriately
        system("bin/rails generate railsui:update")
      end

      Railsui.build_css
      sleep 1
      Railsui.restart

      build_mode_msg = config_params[:build_mode] ? " (#{config_params[:build_mode]} mode)" : ""
      redirect_to root_path(update: true), notice: "✅ App configuration updated successfully#{build_mode_msg}"
    end

    private

    def configuration_params
      params.require(:configuration)
        .permit(
          :application_name,
          :support_email,
          :theme,
          :body_classes,
          :build_mode,
          pages: []
        )
    end
  end
end
