require_dependency "railsui/application_controller"

module Railsui
  class AdminController < ApplicationController
    def show
      @config = Railsui::Configuration.load!
    end
  end
end
