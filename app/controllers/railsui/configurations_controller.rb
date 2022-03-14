require_dependency "railsui/application_controller"

module Railsui
  class ConfigurationsController < ApplicationController
    def create
      Railsui::Configuration.new(configuration_params).save

      # Install deps
      Railsui.bundle
      Railsui.restart

      redirect_to root_path(reload: true), notice: "App is restarting with updated configuration..."
    end

    private

    def configuration_params
      params.require(:configuration)
        .permit(
          :application_name,
          :css_framework,
          :primary_color,
          :secondary_color,
          :tertiary_color,
          :font_family,
          :about,
          :pricing,
          :blog,
          :theme
        )
    end
  end
end
