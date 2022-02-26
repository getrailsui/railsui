require_dependency "railsui/application_controller"

module Railsui
  class AdminController < ApplicationController
    def show
      #@user = User.new add users?
      @config = Railsui::Configuration.load!

      lines = params[:lines]
      @logs = `tail -n #{lines} log/development.log`
    end
  end
end
