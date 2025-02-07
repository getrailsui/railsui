require_dependency "railsui/application_controller"

module Railsui
  class AdminController < ApplicationController
    layout "railsui/fullwidth"
    def show
      @config = Railsui::Configuration.load!
      @theme_pages = Railsui::Pages.installed_pages
    end
  end
end
