require_dependency "railsui/application_controller"

module Railsui
  class AdminController < ApplicationController
    def show
      #@user = User.new add users?
      @config = Railsui::Configuration.load!
    end
  end
end
