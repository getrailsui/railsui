require_dependency "railsui/application_controller"

module Railsui
  class ConfigurationsController < ApplicationController
    def create
      Railsui::Configuration.new(configuration_params).save
      Railsui.bundle

      redirect_to root_path, notice: "Your app configuration updated successfully"
    end

    private

    def configuration_params
      params.require(:configuration)
        .permit(
          :application_name,
          :css_framework,
          :primary_color,
          :secondary_color,
          :about,
          :pricing,
          :theme
        )
    end
  end
end
