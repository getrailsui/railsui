require_dependency "railsui/application_controller"
#require "action_dispatch/routing/inspector"

# https://stackoverflow.com/questions/41802643/how-to-view-rails-routes-for-a-rails-engine-in-the-browser
module Railsui
  class RoutesController < ApplicationController
    layout "railsui/routes"
    def show
      routes = Rails.application.routes.routes
      @routes = ActionDispatch::Routing::RoutesInspector.new(routes)
    end
  end
end
