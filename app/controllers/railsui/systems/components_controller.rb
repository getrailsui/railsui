require_dependency "railsui/application_controller"

module Railsui
  module Systems
    class ComponentsController < ApplicationController
      pages = %w[accordion alert avatar badge breadcrumb button card combobox datalist dropdown flash modal navigation pagination tabs toast tooltip]

      pages.each do |page|
        define_method(page) do
        end
      end
    end
  end
end
