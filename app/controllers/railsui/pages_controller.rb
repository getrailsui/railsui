require_dependency "railsui/application_controller"

module Railsui
  class PagesController < ApplicationController
    layout "railsui/fullwidth"

    def show
      @theme_pages = Railsui::Pages.installed_pages
    end
  end
end
