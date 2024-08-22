require_dependency "railsui/application_controller"

module Railsui
  module Systems
    module Authentication
      class StaticController < ApplicationController
        pages = %w[signup signin confirmation reset_password unlocks change_password overview]

        pages.each do |page|
          define_method(page) do
          end
        end
      end
    end
  end
end
