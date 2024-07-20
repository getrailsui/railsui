require_dependency "railsui/application_controller"

module Railsui
  class ConfigurationsController < ApplicationController
    def create
      config_params = configuration_params.to_h

      Railsui::Configuration.update(config_params)
      Railsui.bundle
      Railsui.build_css
      sleep 1
      Railsui.restart

      redirect_to root_path(update: true), notice: "✅ App configuration updated successfully"
    end

    def delete_page
      title = params[:title]
      # system("rails d railsui:page #{title} --force-plural")
      Railsui::Configuration.delete_page(title)
      sleep 2
      Railsui.restart

      redirect_to root_path, notice: "✅ Page removed successfully"
    end

    private

    def configuration_params
      params.require(:configuration)
        .permit(
          :application_name,
          :support_email,
          :theme,
          pages: [],
          colors: {}
        )
    end
  end
end
