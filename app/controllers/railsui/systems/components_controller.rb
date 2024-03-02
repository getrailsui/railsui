require_dependency "railsui/application_controller"

module Railsui
  module Systems
    class ComponentsController < ApplicationController
      pages = %w[accordion alert badge breadcrumb button card datalist dropdown flash modal navigation pagination tab toast tooltip]

      pages.each do |page|
        define_method(page) do
        end
      end
    end
  end
end
