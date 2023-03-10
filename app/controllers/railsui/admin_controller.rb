require_dependency "railsui/application_controller"

module Railsui
  class AdminController < ApplicationController
    layout "railsui/fullwidth"
    def show
      @config = Railsui::Configuration.load!
      @pages = Railsui::Pages::BASE_PAGES
    end
  end
end
