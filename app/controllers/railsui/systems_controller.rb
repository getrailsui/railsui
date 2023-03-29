require_dependency "railsui/application_controller"

module Railsui
  class SystemsController < ApplicationController
    def show
    end

    def content
    end

    def forms
    end

    def components

    end

    def pages
    end

    def scaffolds
    end

    def icons
      @icons = Dir.chdir(Rails.root.join('app/assets/images/')) do
        Dir.glob("icons/solid/*.svg").sort
      end

      @outline_icons = Dir.chdir(Rails.root.join('app/assets/images/')) do
        Dir.glob("icons/outline/*.svg").sort
      end

    end
  end
end
