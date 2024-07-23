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

    def reset_colors
      theme = Railsui.config.theme

      # Reset colors to the default values for the current theme
      default_colors = Railsui::Colors.theme_colors(theme)
      Railsui::Configuration.update(colors: default_colors)
      Railsui.bundle
      Railsui.build_css
      sleep 2
      Railsui.restart

      redirect_to root_path(update: true), notice: "✅ Colors reset to default for #{theme.humanize} theme"
    end

    private

    def configuration_params
      params.require(:configuration)
        .permit(
          :application_name,
          :support_email,
          :theme,
          :body_classes,
          pages: [],
          colors: {}
        )
    end
  end
end
