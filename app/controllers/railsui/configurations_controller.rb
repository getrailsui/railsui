require_dependency "railsui/application_controller"

module Railsui
  class ConfigurationsController < ApplicationController
    def create
      config = Railsui::Configuration.new(configuration_params)

      if configuration_params[:colors]
        colors_hash = configuration_params[:colors].to_h
        config.colors = convert_keys_to_strings(colors_hash)
      end
      config.save

      Railsui::Configuration.synchronize_pages
      Railsui.bundle
      Railsui.restart
      redirect_to root_path, notice: "✅ App configuration updated successfully"
    end

    def delete_page
      title = params[:title]
      # system("rails d railsui:page #{title} --force-plural")
      Railsui::Configuration.delete_page(title)
      Railsui.restart

      redirect_to root_path, notice: "✅ Page removed successfully"
    end

    private

    def convert_keys_to_strings(hash)
      hash.each_with_object({}) do |(key, value), result|
        new_key = key.to_s
        new_value = value.is_a?(Hash) ? convert_keys_to_strings(value) : value
        result[new_key] = new_value
      end
    end

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
