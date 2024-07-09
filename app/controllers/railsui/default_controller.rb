require_dependency "railsui/application_controller"

module Railsui
  class DefaultController < ApplicationController
    layout "railsui/landing"

    def index
    end

    def start
    end
  end
end
