require_dependency "railsui/application_controller"

module Railsui
  class AdminController < ApplicationController
    layout "railsui/fullwidth"
    def show
      @config = Railsui::Configuration.load!
      @theme_pages = Railsui::Pages.installed_pages
      if @config.theme.present?
        @theme_colors = Railsui::Colors.theme_colors(@config.theme)
      else
        @theme_colors = {}
      end
    end
  end
end
